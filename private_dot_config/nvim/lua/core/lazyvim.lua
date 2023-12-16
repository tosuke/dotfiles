local lazy_opts = {
    defaults = { lazy = true, },
    performance = {
        cache = { enabled = true, },
    },
    change_detection = { notify = false, },
}

require('lazy').setup('plugins', lazy_opts)
