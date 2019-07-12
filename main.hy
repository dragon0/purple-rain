(import random)
(import pygame)

(setv PURPLE (, 138 43 226))
(setv BACKGROUND (, 230 230 250))

(defclass Drop [object]
    (defn --init-- [self x]
        (setv self.x x)
        (setv self.z (random.randint 0 20))
        (self.-inity)
        (setv self.length (self.-map self.z 0 20 10 20)))
        
    (defn fall [self height]
      (setv self.dy (+ self.dy self.gravity))
      (setv self.y (+ self.y self.dy))
      (if (> self.y height)
            (self.-inity)))
    
    (defn show [self surf]
      (pygame.draw.line surf PURPLE
          (, self.x self.y)
          (, self.x (+ self.y self.length))))
         
    (defn -inity [self]
      (setv self.gravity (self.-map self.z 0 20 0 0.2))
      (setv self.dy (self.-map self.z 0 20 4 10))
      (setv self.y (random.randint -500 -50)))

    (defn -map [self n start1 stop1 start2 stop2]
      ;(n - start1) / (stop1 - start1) * (stop2 - start2) + start2
      (* (/ (- n start1) (- stop1 start1)) (+ (- stop2 start2) start2)))
    )

(defclass Game [object]
  (defn --init-- [self width height]
    (setv self.width width)
    (setv self.height height)
    (pygame.init)
    (setv self.screen (pygame.display.set-mode (, self.width self.height)))
    (setv self.clock (pygame.time.Clock))
    (setv self.running True)
    (self.-init))
    
  (defn run [self]
    (while self.running
      (self.clock.tick 60)
      (self.-events)
      (self.-update)
      (self.-draw)))
      
  (defn -init [self]
    (setv self.drops (lfor i (range 500)
        (Drop (random.randint 0 self.width)))))
  
  (defn -events [self]
    (for [event (pygame.event.get)]
      (cond [(= event.type pygame.QUIT) (setv self.running False)]
            [(= event.type pygame.KEYUP) (cond
                [(= event.key pygame.K_ESCAPE) (setv self.running False)])])))
    
  (defn -update [self]
    (for [d self.drops]
      (d.fall self.height)))
    
  (defn -draw [self]
    (self.screen.fill BACKGROUND)
    (for [d self.drops]
      (d.show self.screen))
    (pygame.display.flip)))

(defmain [&rest args]
  (setv game (Game 640 480))
  (game.run))
