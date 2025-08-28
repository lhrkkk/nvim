return {
	{
		"mbbill/undotree",
		keys = { "<leader>u" },
		config = function()
			vim.cmd([[
 noremap <leader>u :UndotreeToggle<CR>
 let g:undotree_DiffAutoOpen = 1
 let g:undotree_SetFocusWhenToggle = 1
 let g:undotree_ShortIndicators = 1
 let g:undotree_WindowLayout = 2
 let g:undotree_DiffpanelHeight = 8
 let g:undotree_SplitWidth = 24
 function g:Undotree_CustomMap()
	nmap <buffer> j <plug>UndotreeNextState
	nmap <buffer> k <plug>UndotreePreviousState
	nmap <buffer> J 5<plug>UndotreeNextState
	nmap <buffer> K 5<plug>UndotreePreviousState
 endfunc]])
		end
	}
}
