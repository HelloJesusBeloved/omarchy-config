--Custom


--Set the borders to fill
   hl.config({
     general = {
       -- No gaps between windows or borders.
       gaps_in = 0,
       gaps_out = 0,
       border_size = 1,
     },
   })

--Disable animations for fullscreen windows only
--Makes swapping windows with ALT + TAB instant instead of animated
hl.window_rule({ match = { fullscreen = true }, no_anim = true })


--End-Custom
