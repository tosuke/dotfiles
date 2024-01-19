import $ from "https://deno.land/x/dax@0.36.0/mod.ts";

export async function main() {
  try {
    await handleMain();
  } catch (e) {
    console.error(e);
    await new Promise((r) => setTimeout(r, 10 * 1000));
    Deno.exit(1);
  }
  Deno.exit(0);
}

async function handleMain() {
  await using cleanup = new AsyncDisposableStack();

  const isatty = Deno.isatty(Deno.stdin.rid);

  const tmpdir = await Deno.makeTempDir();
  cleanup.defer(async () => {
    await Deno.remove(tmpdir, { recursive: true });
  });

  const fifoInPath = `${tmpdir}/fifo-in`;
  if (!isatty) {
    await $`mkfifo ${fifoInPath}`;

    const stdinController = new AbortController();
    const pipingStdin = (async () => {
      const fifoIn = await Deno.open(fifoInPath, { write: true });
      await Deno.stdin.readable.pipeTo(fifoIn.writable, {
        signal: stdinController.signal,
      });
    })();
    cleanup.defer(() => {
      stdinController.abort();
      return pipingStdin;
    });
  }

  // stdout
  const fifoOutPath = `${tmpdir}/fifo-out`;
  await $`mkfifo ${fifoOutPath}`;

  const stdoutController = new AbortController();
  const pipingStdout = (async () => {
    const fifoOut = await Deno.open(fifoOutPath);
    // pipeTo closes stream?
    await fifoOut.readable.pipeTo(Deno.stdout.writable, {
      signal: stdoutController.signal,
      preventClose: true,
    });
  })();
  cleanup.defer(() => {
    stdoutController.abort();
    return pipingStdout;
  });

  // close
  const fifoClosePath = `${tmpdir}/fifo-close`;
  await $`mkfifo ${fifoClosePath}`;
  const waitingClose = (async () => {
    const fifoClose = await Deno.open(fifoClosePath);
    fifoClose.close();
  })();

  const overrideArgs = ["--no-height", "--bind=ctrl-z:ignore"].join(' ')
  const stdinArg = isatty ? "" : `< ${fifoInPath}`;
  const bashCommand =
    `fzf ${overrideArgs} ${stdinArg} > ${fifoOutPath}; echo close > ${fifoClosePath}`;
  const paneID = await $`wezterm cli split-pane -- bash -c ${bashCommand}`.text();
  cleanup.defer(async () => {
    try {
      await $`wezterm cli kill-pane --pane-id=${paneID}`.stderr("null");
    } catch {
      //ignore
    }
  });

  const waitingSignal = (async () => {
    let resolve: (b: true) => void;
    let id: number | undefined;
    const cleanups: Array<() => void> = [];

    const promise = new Promise<true>((res) => {
      resolve = res;
    });

    const handle = () => {
      if (id != null) clearTimeout(id);
      while (cleanups.length > 0) cleanups.pop()?.();
      resolve(true);
    };
    const signals: Deno.Signal[] = ["SIGINT", "SIGTERM"];
    for (const sig of signals) {
      Deno.addSignalListener(sig, handle);
      cleanups.push(() => Deno.removeSignalListener(sig, handle));
    }

    while (true) {
      const timeout = new Promise<false>((r) => {
        id = setTimeout(() => r(false), 1000);
      });
      const result = await Promise.race([promise, timeout]);
      if (result) return;
    }
  })();

  await Promise.any([waitingSignal, waitingClose]);
}

class AsyncDisposableStack {
  #stack: Array<() => void | Promise<void>> = [];
  defer(fn: () => void | Promise<void>) {
    this.#stack.push(fn);
  }
  async dispose() {
    for (let i = this.#stack.length - 1; i >= 0; i--) {
      try {
        await this.#stack[i]();
      } catch (e) {
        console.error(e);
      }
    }
  }
  [Symbol.asyncDispose]() {
    return this.dispose();
  }
}

await main();
