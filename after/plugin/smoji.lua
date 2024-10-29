local smoji = require("smoji")

-- New custom emojis added
local new_items = {
    "🐳 - :whale: - Docker whale is happy!",
    "🌐 - :web: - K8s web of complexity.",
    "🦇 - :batman: - Batman.",
    "🐍 - :snake: - Python slithering through your code.",
    "☕ - :coffee: - Java: Because, why not?",
    "🦀 - :crab: - Rust: Fearless and crabby.",
    "👾 - :bug: - Debugging: Invasion of the bugs.",
    "🤖 - :robot: - AI: When the machine starts to learn.",
    "📜 - :scroll: - Legacy code: Ancient and mysterious.",
    "📊 - :bar_chart: - Optimizing: Because milliseconds matter.",
    "👨‍🍳 - :cooking: - That brother is cooking"
}

local function append_items(existing_items, new_items)
    for _, item in ipairs(new_items) do
        table.insert(existing_items, item)
    end
end

append_items(smoji.items, new_items)

vim.keymap.set("n", "<Leader><Leader>e", "<CMD>Smoji<CR>", { desc = "😂 Smoji" })
