# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

仓库类型：Neovim 配置（~/.config/nvim）

概要
- 该仓库是一套完整的 Neovim 配置，使用 lazy.nvim 作为插件管理器，代码主要位于 lua/ 目录。
- init.lua 依次加载基础选项（defaults）、按键（keymaps）、插件（plugins）与 LSP（lsp）。
- 预置较完善的语言支持与工具链：Lua、Go、Python、JS/TS、Web（HTML/CSS/JSON/Tailwind）、Dart/Flutter，以及 Treesitter 与 DAP 调试。

常用命令（在本仓库中的“开发/维护”动作）
- 同步/安装插件（lazy.nvim）
  - 非交互：nvim --headless "+Lazy! sync" +qa
  - 非交互更新：nvim --headless "+Lazy! update" +qa
  - 非交互清理：nvim --headless "+Lazy! clean" +qa
  - 健康检查：nvim --headless "+Lazy! check" +qa
  - 查看日志：nvim --headless "+Lazy! log" +qa
  - 交互界面：nvim +Lazy
- 更新 Treesitter 解析器
  - nvim --headless "+TSUpdate" +qa
- 管理 LSP 安装（Mason）
  - nvim +Mason
- 当前缓冲区格式化（通过 LSP）
  - 进入 Neovim 后执行：:lua vim.lsp.buf.format()
- 内置 Git 界面（LazyGit 集成）
  - 在 Neovim 中按 Ctrl-g（来自 lazygit.nvim）
- Telescope 常用
  - Ctrl-p：查找文件；Leader d：按严重度查看诊断；Leader :：命令面板
- 调试（nvim-dap + dap-ui）
  - Leader 't 断点开关，Leader n 继续，Leader s 单步，Leader u 面板开关，Leader q 终止
- Flutter 辅助
  - 运行模拟器选择器：:Telescope simulators run；Flutter DAP 由 flutter-tools.nvim 配置

按语言的构建/检查/测试（与本配置的 LSP/工具链相匹配）
- Go
  - 构建：go build ./...
  - 诊断与格式化：go vet ./...；go fmt ./...
  - 全量测试：go test ./...
  - 单测：go test ./路径/到/包 -run TestName
- Python（按需选择工具）
  - Lint：ruff check .（或 pylint）
  - 格式化：ruff format . 或 black .
  - 测试：pytest -q；单测：pytest 路径/测试文件.py::TestClass::test_name -q
- JavaScript/TypeScript（与 ts_ls/biome/eslint 匹配）
  - Lint：npx eslint . 或 npx @biomejs/biome check .
  - 格式化：npx @biomejs/biome format . --write 或 npx prettier -w .
  - 测试（Jest 示例）：npm test 或 npx jest 路径 -t "用例名"
- Dart/Flutter
  - 分析：dart analyze 或 flutter analyze
  - 测试：flutter test；单测：flutter test test/file_test.dart --plain-name "用例名"

环境与依赖要点（源自仓库配置/文档）
- Python3 provider 在 init.lua 中固定为：
  - vim.g.python3_host_prog = "/Users/lhr/.local/share/nvim/py3-venv/bin/python"
  - 若在其它机器/用户名下使用，请更新该路径或在该位置创建带 pynvim 的虚拟环境。
  - 建议在新机器上快速初始化：
    - python3 -m venv ~/.local/share/nvim/py3-venv
    - ~/.local/share/nvim/py3-venv/bin/pip install -U pip pynvim
- README 建议安装的语言服务（全局）：
  - npm i -g vscode-langservers-extracted
  - npm i -g @ansible/ansible-language-server
- Markdown 预览（instant-markdown）所需后端（按需安装其一）：
  - npm i -g instant-markdown-d 或 yarn global add instant-markdown-d
- 首次运行建议：在 Neovim 内执行 :checkhealth 检查。

高层架构（如何拼装到一起）
- 入口
  - init.lua：设置 Python host，依次 require("defaults"), require("keymaps"), require("plugins"), require("lsp").
  - lua/defaults.lua：核心编辑选项、备份/撤销目录、若干自动命令、machine_specific 引导、终端相关映射。
  - lua/keymaps.lua：集中管理按键；Leader 为空格（" "），localleader 为逗号（","）。
- 插件系统（lazy.nvim）
  - lua/plugins.lua 引导 lazy.nvim 并在 require("lazy").setup(...) 中声明插件。
  - 各类插件按功能拆分在 lua/plugins/*.lua，例如 telescope、treesitter、lsp、autocomplete、debugger、git、flutter、go、markdown、editor 工具、UI、搜索等。
  - 自定义工具在 lua/custom_plugins/（compile_run、vertical_cursor_movement、swap_ternary、ctrlu）。
- LSP 体系（lua/lsp）
  - lua/lsp/init.lua：设置诊断显示、合并 cmp_nvim_lsp 能力、在 LspAttach 时一次性启用补全并设置 buffer 级快捷键。
  - 服务器在 lua/lsp/servers/*.lua 通过 vim.lsp.config(...) 定义，再用 vim.lsp.enable(...) 启用。
    - 覆盖：Lua（luals）、Go（gopls）、Python（pyright）、TS/JS（ts_ls + biome + eslint）、Web（html/cssls/jsonls + schemastore for JSON）、tailwindcss、Flutter（flutter-tools）。
  - Mason 与 mason-lspconfig
    - lua/lsp/init.lua 中 ensure_installed 包含 biome、cssls、ts_ls、eslint、gopls、jsonls、html、clangd、dockerls、ansiblels、terraformls、texlab、pyright、yamlls、tailwindcss、taplo、prismals。
    - lua/plugins/mason.lua 也进行 Mason 基础配置（确保 lua_ls 等），并启用自动安装。
  - 保存即格式化
    - 在 lua/lsp/init.lua 的表格式启用：dart/json/go/lua/html/css/js/ts/tsx/c/cpp/objc/objcpp/dockerfile/tex/toml/prisma 等。
- 补全（lua/plugins/autocomplete.lua）
  - nvim-cmp + cmp-nvim-lsp + UltiSnips + lspkind；针对 Dart（冒号项靠前）、Python（下划线前缀靠后）定制 comparator；弹窗样式考虑浅色主题。
- Treesitter（lua/plugins/treesitter.lua）
  - 确保多语言解析器，开启高亮/缩进/增量选择；需要 :TSUpdate 作为构建步骤。
- 调试（lua/plugins/debugger.lua）
  - nvim-dap + dap-ui + virtual-text + telescope-dap；配置 codelldb 适配器与常用调试键位。
- Flutter（lua/lsp/servers/flutter.lua 与 lua/plugins/flutter.lua）
  - flutter-tools 与原生 LSP/nvim-dap 集成；开发日志窗口支持从堆栈轨迹跳转到源码；提供 :Telescope simulators run。
- 语言专项
  - Go：ray-x/go.nvim，保存前 goimport；可用 build 钩子安装/更新工具链。
  - Markdown：instant-markdown（需要 instant-markdown-d 后端，默认不自启）、bullets.vim 等。
  - Git：gitsigns；Ctrl-g 打开 LazyGit。
- 机器特定配置
  - lua/defaults.lua 若检测不到 lua/machine_specific.lua，会从 default_config/_machine_specific_default.lua 拷贝一份；随后 require("machine_specific").

如何扩展/修改
- 增加插件：在 lua/plugins/ 新建一个规格文件，并到 lua/plugins.lua 的列表中 require 它。
- 增加/调整 LSP：在 lua/lsp/servers/ 添加/修改对应语言文件，并通过 vim.lsp.enable('name') 启用；二进制安装用 Mason（nvim +Mason）。
- 调整保存格式化：修改 lua/lsp/init.lua 中的 format_on_save_filetypes 表。

Warp 使用提示
- 该仓库不是“应用源码”的构建仓库；“构建”多指同步插件（Lazy）、更新 Treesitter、安装 LSP（Mason）。
- 多数开发流程为 Neovim 内的交互（Telescope、DAP、LazyGit）。批处理操作（Lazy/TSUpdate）适合用 headless，其余建议直接进入 Neovim 结合快捷键完成。
- 若在不同机器/用户名下，请确认并更新 vim.g.python3_host_prog，随后 :checkhealth。

相关文档位置（本仓库）
- README.md 与 README_cn.md 提供大量按键与依赖说明。日常以 lua/keymaps.lua 为准，插件自带的快捷键通常在对应 lua/plugins/*.lua 附近定义。
