{ config, ... }: 

{
  services.kanata = {
    enable = true;
    keyboards.default.config = # exchanges caps lock and backspace
    "
      (defsrc
        esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet rctl
      )

      (deflayer default
        esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
        grv  1    2    3    4    5    6    7    8    9    0    -    =    @bcp
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    
        bspc a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet rctl
      )  

      (defalias
        bcp ( tap-hold                    200  200  bspc caps  ) ;; tap: bspc, hold: caps
      )
    ";
  };

}