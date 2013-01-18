syntax enable
runtime! plugin/textobj/*.vim




describe 'Named key mappigns'
  it 'is available in proper modes'
    for lhs in ['<Plug>(textobj-syntax-a)', '<Plug>(textobj-syntax-i)']
      Expect maparg(lhs, 'c') == ''
      Expect maparg(lhs, 'i') == ''
      Expect maparg(lhs, 'n') == ''
      Expect maparg(lhs, 'o') != ''
      Expect maparg(lhs, 'v') != ''
    endfor
  end
end




" FIXME: Concrete and revise <Plug>(textobj-syntax-a) semantics.
" FIXME: Currently, the following tests are just a copy of "iy".
describe '<Plug>(textobj-syntax-a)'
  it 'targets a proper range of text'
    enew!
    setfiletype c
    put ='#define ABC 123 /* FIXME: Fix me. */'
    "    0....*....1....*....2....*....3....*.
    "     ------------------------------------  cDefine
    "                 ---                       cNumbers
    "                 ---                       cNumber
    "                     ------------------XX  cComment
    "                     --                --  cCommentStart
    "                        -----              cTodo
    "
    " BUGS: "XX" is not a part of cComment region with the default syntax/c.vim.
    "       But why?  It should be a part of cComment region.

    normal! 1|
    normal yay
    Expect @0 ==# getline('.')

    normal! 10|
    normal yay
    Expect @0 ==# getline('.')

    normal! 15|
    normal yay
    Expect @0 ==# '123'

    normal! 17|
    normal yay
    Expect @0 ==# '/*'

    normal! 19|
    normal yay
    Expect @0 ==# '/* FIXME: Fix me. '

    normal! 20|
    normal yay
    Expect @0 ==# 'FIXME'

    normal! 35|
    normal yay
    Expect @0 ==# '*/'
  end
end




describe '<Plug>(textobj-syntax-i)'
  it 'targets a proper range of text'
    enew!
    setfiletype c
    put ='#define ABC 123 /* FIXME: Fix me. */'
    "    0....*....1....*....2....*....3....*.
    "     ------------------------------------  cDefine
    "                 ---                       cNumbers
    "                 ---                       cNumber
    "                     ------------------XX  cComment
    "                     --                --  cCommentStart
    "                        -----              cTodo
    "
    " BUGS: "XX" is not a part of cComment region with the default syntax/c.vim.
    "       But why?  It should be a part of cComment region.

    normal! 1|
    normal yiy
    Expect @0 ==# getline('.')

    normal! 10|
    normal yiy
    Expect @0 ==# getline('.')

    normal! 15|
    normal yiy
    Expect @0 ==# '123'

    normal! 17|
    normal yiy
    Expect @0 ==# '/*'

    normal! 19|
    normal yiy
    Expect @0 ==# '/* FIXME: Fix me. '

    normal! 20|
    normal yiy
    Expect @0 ==# 'FIXME'

    normal! 35|
    normal yiy
    Expect @0 ==# '*/'
  end
end
