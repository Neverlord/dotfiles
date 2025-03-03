JsOsaDAS1.001.00bplist00�Vscripto"p / /   G e t   c u r r e n t   c o n t e x t . 
 c t x   =   A p p l i c a t i o n . c u r r e n t A p p l i c a t i o n ( ) 
 c t x . i n c l u d e S t a n d a r d A d d i t i o n s   =   t r u e 
 
 / /   S p l i t s   a n   e s c a p e d   s e q u e n c e   o f   s t r i n g s   i n t o   a n   a r r a y   o f   u n e s c a p e d   s t r i n g s .   F o r   e x a m p l e :   ' " 1 , 2 " , 3 , 4 '   b e c o m e s   [ ' 1 , 2 ' ,   3 ,   4 ] . 
 f u n c t i o n   u n e s c a p e A n d S p l i t ( s t r ,   d e l i m i t e r )   { 
     v a r   r e s u l t   =   [ ] 
     v a r   t m p   =   ' ' 
     v a r   i n _ s t r i n g   =   f a l s e 
     f o r   ( v a r   i   =   0 ;   i   <   s t r . l e n g t h ;   + + i )   { 
         v a r   c   =   s t r [ i ] 
         i f   ( i n _ s t r i n g )   { 
 	     i f   ( c   = =   ' " ' ) 
 	         i n _ s t r i n g   =   f a l s e 
 	     e l s e 
 	         t m p   + =   c 
 	 }   e l s e   { 
 	     i f   ( c   = =   ' " ' )   { 
 	         i n _ s t r i n g   =   t r u e 
 	     }   e l s e   i f   ( c   = =   d e l i m i t e r )   { 
 	         r e s u l t . p u s h ( t m p ) 
 	 	 t m p   =   ' ' 
 	     }   e l s e   { 
 	         t m p   + =   c 
 	     } 
 	 } 
     } 
     r e s u l t . p u s h ( t m p ) 
     r e t u r n   r e s u l t 
 } 
 
 / /   R e a d   a   . c s v   f i l e . 
 f u n c t i o n   r e a d A n d S p l i t F i l e ( f i l e ,   d e l i m i t e r )   { 
     / /   C o n v e r t   t h e   f i l e   t o   a   s t r i n g 
     v a r   f i l e S t r i n g   =   f i l e . t o S t r i n g ( ) 
     / /   R e a d   f i l e   v i a   O b j e c t i v e   C ,   b e c a u s e   J X A   c a n n o t   d e a l   w i t h   e n c o d i n g   p r o p e r l y . 
     v a r   e n c   =   $ . N S U T F 8 S t r i n g E n c o d i n g 
     v a r   d a t a   =   O b j C . u n w r a p ( $ . N S S t r i n g . s t r i n g W i t h C o n t e n t s O f F i l e U s e d E n c o d i n g E r r o r ( f i l e S t r i n g ,   e n c ,   n u l l ) ) 
     i f   ( d a t a   = = =   u n d e f i n e d )   { 
         / /   O b j C   g i v e s   u p   o n   L a t i n 1 ,   t r y   a g a i n . 
 	 d a t a   =   O b j C . u n w r a p ( $ . N S S t r i n g . s t r i n g W i t h C o n t e n t s O f F i l e E n c o d i n g E r r o r ( f i l e S t r i n g ,   $ . N S I S O L a t i n 1 S t r i n g E n c o d i n g ,   n u l l ) ) 
     } 
     r e t u r n   d a t a . s p l i t ( d e l i m i t e r ) 
 } 
 
 / /   R e a d   a   . c s v   f i l e . 
 f u n c t i o n   r e a d F i l e L i n e s ( f i l e )   { 
     r e t u r n   r e a d A n d S p l i t F i l e ( f i l e ,   / \ r ? \ n / ) 
 } 
 
 / / /   C o n v e r t s   ' 1 , 2 3 '   t o   ' 1 . 2 3 '   r e p r e s e n t a t i o n . 
 f u n c t i o n   c o n v e r D e c i m a l S e p a r a t o r ( x )   { 
     r e t u r n   x . r e p l a c e ( ' . ' ,   ' ' ) . r e p l a c e ( ' , ' ,   ' . ' ) 
 } 
 
 f u n c t i o n   i m p o r t C o m m e r z b a n k C h e c k i n g s ( f i l e C o n t e n t )   { 
     / /   C S V   F o r m a t :   B o o k i n g   d a t e ; V a l u e   d a t e ; T r a n s a c t i o n   t y p e ; B o o k i n g   t e x t ; A m o u n t ; C u r r e n c y ; A c c o u n t   I B A N ; C a t e g o r y 
     / /   O u r   F o r m a t :   D a t u m ; B e t r a g ; B u c h u n g s t e x t 
     / /   E m p t y   f i r s t   c o l u m n s   ( d a t e )   i n d i c a t e   s c h e d u l e d   t r a n s a c t i o n s   ( i g n o r e ) . 
     r e t u r n   f i l e C o n t e n t . s l i c e ( 1 ) 
 	 	   . m a p ( x   = >   u n e s c a p e A n d S p l i t ( x ,   ' ; ' ) ) 
                   . f i l t e r ( x   = >   x . l e n g t h   > =   5   & &   x [ 0 ]   ! =   ' ' ) 
 	 	   . m a p ( x   = >   [ x [ 0 ] ,   c o n v e r D e c i m a l S e p a r a t o r ( x [ 4 ] ) ,   x [ 3 ] ] ) 
 	 	   . r e v e r s e ( ) 
 } 
 
 f u n c t i o n   i m p o r t N 2 6 ( f i l e C o n t e n t )   { 
     / /   C S V   F o r m a t :   " B o o k i n g   D a t e " , " V a l u e   D a t e " , " P a r t n e r   N a m e " , " P a r t n e r   I b a n " , T y p e , " P a y m e n t   R e f e r e n c e " , " A c c o u n t   N a m e " , " A m o u n t   ( E U R ) " , " O r i g i n a l   A m o u n t " , " O r i g i n a l   C u r r e n c y " , " E x c h a n g e   R a t e " 
     / /   O u r   F o r m a t :   D a t u m ; B e t r a g ; B u c h u n g s t e x t 
     / /   E m p t y   f i r s t   c o l u m n s   ( d a t e )   i n d i c a t e   s c h e d u l e d   t r a n s a c t i o n s   ( i g n o r e ) . 
     r e t u r n   f i l e C o n t e n t . s l i c e ( 1 ) 
 	 	   . m a p ( x   = >   u n e s c a p e A n d S p l i t ( x ,   ' , ' ) ) 
                   . f i l t e r ( x   = >   x . l e n g t h   > =   1 1   & &   x [ 1 ]   ! =   ' ' ) 
 	 	   . m a p ( x   = >   [ x [ 0 ] ,   x [ 7 ] ,   x [ 2 ]   +   ' :   '   +   x [ 5 ] ] ) 
 } 
 
 f u n c t i o n   i m p o r t L b b ( f i l e C o n t e n t )   { 
     / /   C S V   F o r m a t :   K r e d i t k a r t e n n u m m e r ; T r a n s a k t i o n s d a t u m ; B u c h u n g s d a t u m ; H � n d l e r ; U m s a t z k a t e g o r i e ; B e t r a g   i n   F r e m d w � h r u n g ; E i n h e i t   F r e m d w � h r u n g ; U m r e c h n u n g s k u r s ; B e t r a g   i n   E u r o ; . . . 
     / /   O u r   F r o m a t :   D a t u m ; B e t r a g ; B e s c h r e i b u n g 
     r e t u r n   f i l e C o n t e n t . s l i c e ( 2 ) 
 	 	   . m a p ( x   = >   u n e s c a p e A n d S p l i t ( x ,   ' ; ' ) ) 
 	 	   . f i l t e r ( x   = >   x . l e n g t h   > =   9   & &   x [ 8 ]   ! =   ' ' ) 
 	 	   . m a p ( x   = >   [ x [ 1 ] ,   - c o n v e r D e c i m a l S e p a r a t o r ( x [ 8 ] ) ,   x [ 3 ] ] ) 
 	 	   . r e v e r s e ( ) 
 } 
 
 f u n c t i o n   i m p o r t H a s p a ( f i l e C o n t e n t )   { 
     / /   C S V   F o r m a t :   A u f t r a g s k o n t o ; B u c h u n g s t a g ; V a l u t a d a t u m ; B u c h u n g s t e x t ; V e r w e n d u n g s z w e c k ; G l a e u b i g e r   I D ; M a n d a t s r e f e r e n z ; K u n d e n r e f e r e n z   ( E n d - t o - E n d ) ; S a m m l e r r e f e r e n z ; L a s t s c h r i f t   U r s p r u n g s b e t r a g ; A u s l a g e n e r s a t z   R u e c k l a s t s c h r i f t ; B e g u e n s t i g t e r / Z a h l u n g s p f l i c h t i g e r ; K o n t o n u m m e r / I B A N ; B I C   ( S W I F T - C o d e ) ; B e t r a g ; W a e h r u n g ; I n f o 
     / /   O u r   F r o m a t :   D a t u m ; B e t r a g ; B e s c h r e i b u n g 
     r e t u r n   f i l e C o n t e n t . s l i c e ( 1 ) . r e v e r s e ( ) 
 	 	   . m a p ( x   = >   u n e s c a p e A n d S p l i t ( x ,   ' ; ' ) ) 
                   . f i l t e r ( x   = >   x . l e n g t h   > =   1 7   & &   x [ 0 ]   ! =   ' ' ) 
 	 	   . m a p ( x   = >   [ x [ 1 ] ,   c o n v e r D e c i m a l S e p a r a t o r ( x [ 1 4 ] ) ,   x [ 4 ] ] ) 
 } 
 
 f u n c t i o n   i m p o r t F i d o r ( f i l e C o n t e n t )   { 
     / /   C S V   F o r m a t :   D a t u m ; B e s c h r e i b u n g ; B e s c h r e i b u n g 2 ; W e r t 
     / /   O u r   F r o m a t :   D a t u m ; B e t r a g ; B e s c h r e i b u n g 
     r e t u r n   f i l e C o n t e n t . s l i c e ( 1 ) . r e v e r s e ( ) 
 	 	   . m a p ( x   = >   u n e s c a p e A n d S p l i t ( x ,   ' ; ' ) ) 
                   . f i l t e r ( x   = >   x . l e n g t h   > =   4   & &   x [ 0 ]   ! =   ' ' ) 
 	 	   . m a p ( x   = >   [ x [ 0 ] ,   c o n v e r D e c i m a l S e p a r a t o r ( x [ 3 ] ) ,   x [ 1 ]   +   '   '   +   x [ 2 ] ] ) 
 } 
 
 f u n c t i o n   g u e s s S h e e t ( c s v F i l e N a m e ,   c s v F i l e C o n t e n t )   { 
     i f   ( c s v F i l e C o n t e n t [ 0 ] . s t a r t s W i t h ( ' B o o k i n g   d a t e ; V a l u e   d a t e ; T r a n s a c t i o n   t y p e ; B o o k i n g   t e x t ; ' ) ) 
         r e t u r n   ' C o m m e r z b a n k ' 
     i f   ( c s v F i l e C o n t e n t [ 0 ] . s t a r t s W i t h ( ' " B o o k i n g   D a t e " , " V a l u e   D a t e " , " P a r t n e r   N a m e " ' ) ) 
         r e t u r n   ' N 2 6 ' 
     t h r o w   ' U n r e c o g n i z e d   . c s v   f i l e   f o r m a t . ' 
 } 
 
 f u n c t i o n   g e t I m p o r t e r ( s h e e t N a m e )   { 
     i f   ( s h e e t N a m e . s t a r t s W i t h ( ' C o m m e r z b a n k ' ) ) 
         r e t u r n   i m p o r t C o m m e r z b a n k C h e c k i n g s 
     i f   ( s h e e t N a m e   = =   ' N 2 6 ' ) 
         r e t u r n   i m p o r t N 2 6 
     i f   ( s h e e t N a m e   = =   ' L B B ' ) 
     	 r e t u r n   i m p o r t L b b 
     i f   ( s h e e t N a m e   = =   ' S p a r d a ' ) 
         r e t u r n   i m p o r t S p a r d a 
     i f   ( s h e e t N a m e   = =   ' H a s p a ' ) 
         r e t u r n   i m p o r t H a s p a 
     i f   ( s h e e t N a m e   = =   ' F i d o r ' ) 
         r e t u r n   i m p o r t F i d o r 
     t h r o w   ' N o   i m p o r t e r   f o u n d   f o r   '   +   n a m e   +   ' . ' 
 } 
 
 / / /   C h e c k s   w h e t h e r   a   s h e e t ,   d o c u m e n t   o r   t a b l e   i s   v a l i d . 
 f u n c t i o n   c h e c k V a l i d ( x ,   e r r o r M s g )   { 
     t r y   {   x . n a m e ( )   } 
     c a t c h   ( e r r )   {   t h r o w   e r r o r M s g   } 
 } 
 
 / * 
 f u n c t i o n   u p d a t e A c t i v i t y S h e e t ( d o c )   { 
     / /   C o n f i g u r a t i o n . 
     c o n s t   c o n v e r s i o n S h e e t N a m e   =   ' C o n v e r s i o n ' 
     c o n s t   c o n v e r s i o n T a b l e N a m e   =   ' R a t e ' 
     c o n s t   a c t i v i t y S h e e t N a m e   =   ' A c t i v i t y ' 
     c o n s t   a c t i v i t y T a b l e N a m e   =   ' A c c o u n t s ' 
     / /   G e t   c o n v e r s i o n   t a b l e . 
     v a r   c o n v e r s i o n S h e e t   =   d o c . s h e e t s [ c o n v e r s i o n S h e e t N a m e ] 
     v a r   c o n v e r s i o n T a b l e   =   c o n v e r s i o n S h e e t . t a b l e s [ c o n v e r s i o n T a b l e N a m e ] 
     v a r   c o n v e r s i o n s   =   { } 
     c o n s t   h o m e C u r r e n c y   =   c o n v e r s i o n T a b l e . c o l u m n s [ 1 ] . c e l l s [ 0 ] . v a l u e ( ) 
     f o r   ( v a r   i   =   1 ;   i   <   c o n v e r s i o n T a b l e . r o w C o u n t ( ) ;   + + i )   { 
         v a r   c u r r e n c y   =   c o n v e r s i o n T a b l e . c o l u m n s [ 0 ] . c e l l s [ i ] . v a l u e ( ) 
         c o n v e r s i o n s [ c u r r e n c y ]   =   c o n v e r s i o n S h e e t N a m e   +   ' : : '   +   c o n v e r s i o n T a b l e N a m e   +   ' : : B '   +   ( i   +   1 ) 
     } 
     / /   F e t c h   k e y   t a b l e s . 
     v a r   t a r g e t T a b l e   =   d o c . s h e e t s [ a c t i v i t y S h e e t N a m e ] . t a b l e s [ a c t i v i t y T a b l e N a m e ] 
     / /   G e t   t h e   n a m e s   o f   a l l   a c c o u n t   s h e e t s   f r o m   t h e   t a r g e t   t a b l e .   N o t e   t h a t   t h e 
     / /   t a b l e   h a s   a   s u m m a r y   o n   t h e   l a s t   r o w ,   w h i c h   i s   s t o p   a t   r o w C o u n t   -   1 . 
     v a r   s h e e t N a m e s   =   [ ] 
     v a r   s h e e t N a m e s C o l u m n   =   t a r g e t T a b l e . c o l u m n s [ 0 ] 
     f o r   ( v a r   i   =   1 ;   i   <   t a r g e t T a b l e . r o w C o u n t ( )   -   1 ;   + + i )   { 
         s h e e t N a m e s . p u s h ( s h e e t N a m e s C o l u m n . c e l l s [ i ] . v a l u e ( ) ) 
     } 
     f o r   ( v a r   s h e e t I d   =   0 ;   s h e e t I d   <   s h e e t N a m e s . l e n g t h ;   + + s h e e t I d )   { 
         v a r   s h e e t   =   d o c . s h e e t s [ s h e e t N a m e s [ s h e e t I d ] ] 
         v a r   t a b l e   =   s h e e t . t a b l e s [ a c t i v i t y S h e e t N a m e ] 
         / /   I n i t i a l i z e   ' f i e l d s '   t o   b e   a n   a r r a y   o f   1 2   a r r a y s : 
         / /   o n e   a r r a y   f o r   e a c h   m o n t h   i n   t h e   y e a r . 
         v a r   f i e l d s   =   [ ] 
         f o r   ( v a r   i   =   0 ;   i   <   1 2 ;   + + i ) 
             f i e l d s . p u s h ( { ' f i r s t '   :   0 ,   ' l a s t '   :   0 } ) 
         v a r   c o l u m n s   =   t a b l e . c o l u m n s 
         v a r   c u r r e n c y   =   c o l u m n s [ 1 ] . c e l l s [ 0 ] . v a l u e ( ) 
         f o r   ( v a r   i   =   1 ;   i   <   t a b l e . r o w C o u n t ( ) ;   + + i )   { 
             v a r   m o n t h   =   c o l u m n s [ 0 ] . c e l l s [ i ] . v a l u e ( ) . g e t M o n t h ( ) 
         i f   ( f i e l d s [ m o n t h ] . f i r s t   = =   0 ) 
             f i e l d s [ m o n t h ] . f i r s t   =   i   +   1 
             f i e l d s [ m o n t h ] . l a s t   =   i   +   1 
         } 
         v a r   t a r g e t R o w   =   t a r g e t T a b l e . r o w s [ s h e e t I d   +   1 ] 
         f o r   ( v a r   i   =   0 ;   i   <   1 2 ;   + + i )   { 
             i f   ( f i e l d s [ i ] . f i r s t   >   0 )   { 
                 v a r   s u m   =   ' ' 
                 i f   ( f i e l d s [ i ] . f i r s t   = =   f i e l d s [ i ] . l a s t ) 
                     s u m   =   ' = '   +   s h e e t . n a m e ( )   +   ' : : '   +   t a b l e . n a m e ( )   +   ' : : B '   +   f i e l d s [ i ] . f i r s t 
                 e l s e 
                     s u m   =   ' = S U M ( '   +   s h e e t . n a m e ( )   +   ' : : '   +   t a b l e . n a m e ( )   +   ' : : B '   +   f i e l d s [ i ] . f i r s t   +   ' : B '   +   f i e l d s [ i ] . l a s t   +   ' ) ' 
                 i f   ( c u r r e n c y   = =   h o m e C u r r e n c y )   { 
                         t a r g e t R o w . c e l l s [ i   +   1 ] . v a l u e   =   s u m 
                 }   e l s e   { 
                     t a r g e t R o w . c e l l s [ i   +   1 ] . v a l u e   =   s u m   +   ' * '   +   c o n v e r s i o n s [ c u r r e n c y ] 
                 } 
             } 
         } 
     } 
 } 
 * / 
 
 f u n c t i o n   m a i n ( )   { 
     / /   C h e c k   w h e t h e r   ' N u m b e r s '   i s   r u n n i n g . 
     v a r   n s   =   A p p l i c a t i o n ( ' N u m b e r s ' ) 
     i f   ( ! n s . r u n n i n g ( ) ) 
         t h r o w   ' N u m b e r s   i s   n o t   r u n n i n g ' 
     / /   C h e c k   w h e t h e r   ' N u m b e r s '   h a s   a t   l e a s t   o n e   o p e n   d o c u m e n t . 
     i f   ( n s . d o c u m e n t s . l e n g t h   = =   0 ) 
         t h r o w   ' N u m b e r s   h a s   n o   o p e n   d o c u m e n t ' 
     / /   F e t c h   c u r r e n t   d o c u m e n t . 
     v a r   d o c   =   n s . d o c u m e n t s [ 0 ] 
     c h e c k V a l i d ( d o c ,   ' C a n n o t   a c c e s s   d o c u m e n t ' ) 
     / /   S e l e c t   . c s v   f i l e . 
     v a r   c s v F i l e s   =   c t x . c h o o s e F i l e ( { 
         o f T y p e :   " c s v " ,  
         w i t h P r o m p t :   " S e l e c t   C S V   f i l e ( s )   t o   p r o c e s s : " , 
 	 m u l t i p l e S e l e c t i o n s A l l o w e d :   t r u e ,  
     } ) 
     f o r   ( v a r   i   =   0 ;   i   <   c s v F i l e s . l e n g t h ;   + + i )   { 
         v a r   c s v F i l e N a m e   =   c s v F i l e s [ i ] . t o S t r i n g ( ) 
 	 v a r   c s v F i l e C o n t e n t   =   r e a d F i l e L i n e s ( c s v F i l e N a m e ) 
         / /   G e t   t h e   n a m e   o f   t h e   t a r g e t   s h e e t . 
         v a r   s h e e t N a m e   =   g u e s s S h e e t ( c s v F i l e N a m e ,   c s v F i l e C o n t e n t ) 
         v a r   s h e e t   =   d o c . s h e e t s [ s h e e t N a m e ] 
         c h e c k V a l i d ( s h e e t ) 
         v a r   i m p o r t e r   =   g e t I m p o r t e r ( s h e e t N a m e ) 
         / /   R e a d   C S V   f i l e ,   d r o p   h e a d e r   r o w , 
         / /   r e v e r s e   i t   ( C o m m e r z b a n k   s o r t s   . c s v   f i l e s   f r o m   n e w   t o   o l d   b u t   w e   s o r t   c h r o n o l o g i c a l l y ) 
         / /   a n d   s p l i t   a t   t h e   ;   d e l i m i t e r . 
         v a r   x s   =   i m p o r t e r ( c s v F i l e C o n t e n t ) 
         / /   F e t c h   ' A c t i v i t y '   t a b l e   a n d   a b o r t   i f   n o n e   e x i s t s . 
         v a r   t a b l e   =   s h e e t . t a b l e s [ ' A c t i v i t y ' ] 
         t r y   {   t a b l e . n a m e ( )   } 
         c a t c h   ( e r r )   {   t h r o w   ' C a n n o t   a c c e s s   t a b l e   " A c t i v i t y " '   } 
         / /   I n s e r t   a l l   e n t r i e s   f r o m   t h e   C S V   f i l e   t o   t h e   t a b l e . 
         n s . a c t i v a t e ( ) 
         x s . f o r E a c h ( f u n c t i o n ( x )   { 
             v a r   r o w   =   t a b l e . r o w s [ t a b l e . r o w C o u n t ( )   -   1 ] . a d d R o w B e l o w ( ) 
             f o r   ( v a r   i   =   0 ;   i   <   x . l e n g t h ;   + + i ) 
                 r o w . c e l l s [ i ] . v a l u e   =   x [ i ] 
         } ) 
     } 
     / / u p d a t e A c t i v i t y S h e e t ( d o c ) 
     r e t u r n   1 
 } 
 
 t r y   { 
     m a i n ( ) 
 } 
 c a t c h   ( e r r )   { 
     v a r   m s g   =   e r r . t o S t r i n g ( ) 
     i f   ( m s g   ! =   ' E r r o r :   U s e r   c a n c e l e d . ' ) 
         c t x . d i s p l a y D i a l o g ( e r r . t o S t r i n g ( ) ,   { 
             w i t h I c o n :   ' c a u t i o n ' , 
 	     b u t t o n s :   [ ' O k ' ] , 
         } ) 
 }                              D�jscr  ��ޭ