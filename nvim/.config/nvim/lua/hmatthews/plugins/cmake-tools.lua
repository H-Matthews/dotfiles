-- lua/plugins/cmake-tools.lua
return {
  "Civitasv/cmake-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "cpp", "c", "cmake" }, -- only load in relevant filetypes
  config = function()
    require("cmake-tools").setup({
      cmake_command = "cmake",
      cmake_build_directory = "build",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_soft_link_compile_commands = true, -- symlinks compile_commands.json to project root, this is what clangd needs
      cmake_kits_path = nil,
      cmake_variants_message = {
        short = { show = true },
        long = { show = true, max_length = 40 },
      },
      cmake_executor = {
        name = "quickfix",
        opts = {
          -- "belowright" (not "botright") keeps the window confined to your current editing
          -- column, so it never spans full-screen-width and pushes into the nvim-tree sidebar.
          -- Trade-off: it opens relative to whichever window is focused, so if you're nested in
          -- extra horizontal splits it can land above the true bottom of the screen.
          position = "belowright",
          size = 10,
          auto_close_when_success = false, -- keep the window open after a successful build instead of auto-closing it
        },
      },
    })

    local map = vim.keymap.set

    -- Toggle build-output window (like <leader>e toggles nvim-tree)
    local function toggle_cmake_executor()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "quickfix" then
          vim.cmd("CMakeCloseExecutor")
          return
        end
      end
      vim.cmd("CMakeOpenExecutor")
    end

    -- Toggle run window
    local function toggle_cmake_runner()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "cmake_tools_terminal" then
          vim.cmd("CMakeCloseRunner")
          return
        end
      end
      vim.cmd("CMakeOpenRunner")
    end

    map("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
    map("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
    map("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })
    map("n", "<leader>cd", "<cmd>CMakeDebug<cr>", { desc = "CMake Debug" }) -- needs nvim-dap installed to actually work
    map("n", "<leader>cv", toggle_cmake_executor, { desc = "Toggle build output" })
    map("n", "<leader>co", toggle_cmake_runner, { desc = "Toggle run window" })
    map("n", "<leader>cx", "<cmd>CMakeStopExecutor<cr>", { desc = "Stop build" })
    map("n", "<leader>cX", "<cmd>CMakeStopRunner<cr>", { desc = "Stop running target" })
    map("n", "<leader>cs", "<cmd>CMakeSelectBuildType<cr>", { desc = "Select build type" })
    map("n", "<leader>ct", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "Select launch target" })
  end,
}
