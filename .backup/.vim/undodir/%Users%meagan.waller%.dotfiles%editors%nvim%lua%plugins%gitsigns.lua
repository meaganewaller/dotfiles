Vim�UnDo� ��'�D�ų�Ѐ��#�,��-��r�pZ}   /           
                       g5�    _�                             ����                                                                                                                                                                                                                                                                                                                                                             g��     �   &              
          �   '            �                                 auto_attach�               �                   �               5��                                          �      �                     
   �              �      �    &   
                 �                    5�_�                            ����                                                                                                                                                                                                                                                                                                                                       2           v        g��    �       3       2   return {       {   "        "lewis6991/gitsigns.nvim",           config = function()   '            require('gitsigns').setup {   0                signs                        = {   4                    add          = { text = '│' },   4                    change       = { text = '│' },   2                    delete       = { text = '_' },   4                    topdelete    = { text = '‾' },   2                    changedelete = { text = '~' },   4                    untracked    = { text = '┆' },                   },   ]                signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`   ]                numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`   ^                linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`   a                word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`   0                watch_gitdir                 = {   '                    follow_files = true                   },   4                auto_attach                  = true,   4                attach_to_untracked          = true,   j                current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`   0                current_line_blame_opts      = {   %                    virt_text = true,   O                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'   !                    delay = 1000,   .                    ignore_whitespace = false,   -                    virt_text_priority = 100,                   },   ^                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',   1                sign_priority                = 6,   3                update_debounce              = 100,   D                status_formatter             = nil,   -- Use default   g                max_file_length              = 40000, -- Disable if file is longer than this (in lines)   0                preview_config               = {   6                    -- Options passed to nvim_open_win   &                    border = 'single',   &                    style = 'minimal',   (                    relative = 'cursor',                       row = 0,                       col = 1                   },   0                yadm                         = {   "                    enable = false                   },               }           end       },   }5��                         	                     �                                              �                         ,                     �                         D                     �                         f                     �                      
   �              
       �                      
   �              
       �                      
   �              
       �    	                  
                
       �    
                  
   9             
       �                      
   b             
       �                         �                    �                         �                    �                         �                    �                         D                    �                         �                    �                         �                    �                      
                
       �                         <                    �                         G                    �                         t                    �                         �                    �                                             �                      
   -             
       �                      
   I             
       �                      
   �             
       �                      
   �             
       �                      
   �             
       �                         �                    �                         �                    �                         R                    �                          |                    �    !                     �                    �    "                     �                    �    #                     E                    �    $                  
   n             
       �    %                  
   �             
       �    &                  
   �             
       �    '                  
   �             
       �    (                  
   �             
       �    )                  
                
       �    *                                         �    +                     $                    �    ,                  
   M             
       �    -                     f                    �    .                     q                    �    /                     y                    �    0                     �                    5�_�                    ,       ����                                                                                                                                                                                                                                                                                                                                                             g��     �   +   ,          (        yadm                         = {5��    +                      $      )               5�_�                    ,       ����                                                                                                                                                                                                                                                                                                                                                             g��     �   +   ,                    enable = false5��    +                      $                     5�_�                    ,       ����                                                                                                                                                                                                                                                                                                                                                             g��    �   +   ,          
        },5��    +                      $                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             g5�     �         0      
          �         0    �         /    5��                          �               	       �                         �                     �       
                  �                      �       
              0   �                     5�_�                       )    ����                                                                                                                                                                                                                                                                                                                                                             g5�     �                *          add          = { text = '│' },5��                          �      +               5�_�      	                 )    ����                                                                                                                                                                                                                                                                                                                                                             g5�     �                *          change       = { text = '│' },5��                          �      +               5�_�      
           	      '    ����                                                                                                                                                                                                                                                                                                                                                             g5�     �                (          delete       = { text = '_' },5��                          �      )               5�_�   	              
      )    ����                                                                                                                                                                                                                                                                                                                                                             g5�     �                *          topdelete    = { text = '‾' },5��                          �      +               5�_�   
                    '    ����                                                                                                                                                                                                                                                                                                                                                             g5�     �                (          changedelete = { text = '~' },5��                          �      )               5�_�                       )    ����                                                                                                                                                                                                                                                                                                                                                             g5�     �                *          untracked    = { text = '┆' },5��                          �      +               5�_�                        	    ����                                                                                                                                                                                                                                                                                                                               	          	       v   	    g5�    �                (        signs                        = {   0                add          = { text = '▎' },   0                change       = { text = '░' },   .                delete       = { text = '_' },   0                topdelete    = { text = '▔' },   0                changedelete = { text = '▒' },   0                untracked    = { text = '┆' },   
        },5��                      
   �              
       �                      
   �              
       �                      
   �              
       �    	                  
                
       �    
                  
   9             
       �                      
   d             
       5��