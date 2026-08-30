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
    })

    local map = vim.keymap.set
    map("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
    map("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
    map("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })
    map("n", "<leader>cd", "<cmd>CMakeDebug<cr>", { desc = "CMake Debug" }) -- needs nvim-dap installed to actually work
    map("n", "<leader>cc", "<cmd>CMakeClose<cr>", { desc = "Close CMake console" })
    map("n", "<leader>cs", "<cmd>CMakeSelectBuildType<cr>", { desc = "Select build type" })
    map("n", "<leader>ct", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "Select launch target" })
  end,
}
