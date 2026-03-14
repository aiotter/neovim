{ mini-nvim }:
{
  plugin = mini-nvim;
  config.lua = ''
    local miniclue = require("mini.clue")

    local leader_triggers = {
      { mode = "i", keys = "<C-x>" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "n", keys = "\"" },
      { mode = "x", keys = "\"" },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "<LocalLeader>" },
      { mode = "x", keys = "<LocalLeader>" },
    }

    local leader_group_clues = {
      { mode = "n", keys = "<LocalLeader>g", desc = "+Git" },
      { mode = "n", keys = "<LocalLeader>gh", desc = "+Git hunk" },
      { mode = "n", keys = "<LocalLeader>l", desc = "+LSP" },
    }

    miniclue.setup({
      triggers = leader_triggers,
      clues = {
        leader_group_clues,
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },

      window = {
        delay = 500,
      },
    })
  '';
}
