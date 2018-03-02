//
//  ViewController.swift
//  SlimeVolleyball
//
//  Created by Zach Walravens on 8/27/16.
//  Copyright © 2016 Warzac. All rights reserved.
//

import UIKit

var newX = 0
var newY = 0

let slimeRadius = CGFloat(74)
let basRadius = CGFloat(170)

var redGoingTo = CGFloat(0)
var blueGoingTo = CGFloat(0)
var moveSpeed = CGFloat(8)

var ballVelocityX = CGFloat(5)
var ballVelocityY = CGFloat(0)

var rGoingLeft = false
var rGoingRight = false
var bGoingLeft = false
var bGoingRight = false

var GRAVITY = 0.4

class ViewController: UIViewController {
    
    var i = 0
    var hitspot = CGFloat(0)
    var lastHit = ""
    var surfangle = 0.0
    var gravity = GRAVITY
    var newPlayTimer = 151

    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("a" != "a")

        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapAction(_:)))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        

        let timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(ViewController.timerAction), userInfo: nil, repeats: true)
        
        
       // redGoingTo = redSlime.frame.width/2
       // blueGoingTo = view.frame.width - blueSlime.frame.width/2
        
        ball.frame.origin.x = 50
        ball.frame.origin.y = 20
        
        ballVelocityX = 0.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    
    @IBOutlet weak var redSlime: UIImageView!
    
    @IBOutlet weak var blueSlime: UIImageView!

    @IBOutlet weak var net: UIView!
    
    @IBOutlet weak var ball: UIImageView!
    
    @IBOutlet weak var rLeft: UIButton!
    
    @IBOutlet weak var rRight: UIButton!
    
    @IBOutlet weak var bLeft: UIButton!
    
    @IBOutlet weak var bRight: UIButton!
    
    

    
    @IBAction func rLeftDown(sender: UIButton) {
        rGoingLeft = true
        rGoingRight = false
    }
    
    @IBAction func rLeftUp(sender: UIButton) {
        rGoingLeft = false
    }
    
    @IBAction func rRightDown(sender: UIButton) {
        rGoingRight = true
        rGoingLeft = false
    }
    
    @IBAction func rRightUp(sender: UIButton) {
        rGoingRight = false
    }
    
    @IBAction func bLeftDown(sender: UIButton) {
        bGoingLeft = true
        bGoingRight = false
    }
    
    @IBAction func bLeftUp(sender: UIButton) {
        bGoingLeft = false
    }
    
    @IBAction func bRightDown(sender: UIButton) {
        bGoingRight = true
        bGoingLeft = false
    }
    
    @IBAction func bRightUp(sender: UIButton) {
        bGoingRight = false
    }
    
    
    
    
    func tapAction(touch: UITapGestureRecognizer) {
        
        let touchPoint = touch .locationInView(self.view)
        debugPrint(touchPoint.x)
        debugPrint(touchPoint.y)
        
        
        if (touchPoint.x > view.frame.width/2) {
        //    blueGoingTo = touchPoint.x
        }
        else {
       //     redGoingTo = touchPoint.x
        }

    }
    
    
    func distance(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat {
        
        return pow(pow(x2 - x1, 2) + pow(y2 - y1, 2), 0.5)

    }
    
    func deflection(angleOfSurface: CGFloat, multiplier: CGFloat) {
        
        let speedOld = distance(CGFloat(0), y1: CGFloat(0), x2: ballVelocityX, y2: ballVelocityY)
        
        if speedOld != 0.0 {
            var directionOld = CGFloat(acos(Double(ballVelocityX/speedOld)) * 180 / M_PI)
            if ballVelocityY < 0 {
                directionOld = 360 - directionOld
            }
        
            var directionNew = (2*angleOfSurface - directionOld) % 360
            directionNew = directionNew * (CGFloat(M_PI)/180)
        
            let YNew = sin(directionNew) * speedOld * multiplier
            let XNew = cos(directionNew) * speedOld * multiplier
        
            ballVelocityY = YNew
            ballVelocityX = XNew
        }
    }
    
    func timerAction() {
        
        //Increase new play timer
        if newPlayTimer < 150  {
            newPlayTimer += 1
        }
        
        //Start new play
        if newPlayTimer == 150 {
            ball.frame.origin.x = redSlime.frame.origin.x + redSlime.frame.width/2
            ball.frame.origin.y = 20
            
            ballVelocityX = 0.0
            ballVelocityY = 0.0
            
            gravity = GRAVITY
            
            lastHit = ""
            
            newPlayTimer += 1
        }
        
        //Reset lasthit if vertical velocity is 0
        if Double(ballVelocityY) > -1 * gravity && Double(ballVelocityY) < gravity && ball.frame.origin.y < view.frame.height - net.frame.height - 5 {
            lastHit = ""
            debugPrint("RESET BECAUSE 0 VERTICAL VELOCITY")
        }
        
        
        
        //Move ball w/ velocity
        ball.frame.origin.x = ball.frame.origin.x + ballVelocityX
        ball.frame.origin.y = ball.frame.origin.y + ballVelocityY
        
        //Accelerate ball due to gravity
        ballVelocityY = ballVelocityY + CGFloat(gravity)
        
        //If hits ground
        if ball.frame.origin.y + ball.frame.height/2 + 20 > view.frame.height && ballVelocityY > 0 {
            ballVelocityY = 0
            ballVelocityX = 0
            gravity = 0
            lastHit = "g"
            
            debugPrint("HIT GROUND")
            
            newPlayTimer = 0
        }
      
        
        //If hits top of net
        if ball.frame.origin.x <= net.frame.origin.x + net.frame.width && ball.frame.origin.x + ball.frame.width >= net.frame.origin.x && ball.frame.origin.y + ball.frame.height > view.frame.height - net.frame.height && ball.frame.origin.y + ball.frame.height < view.frame.height + ballVelocityY*1.5 - net.frame.height && lastHit != "n" {
            deflection(0, multiplier: CGFloat(1.0))
            debugPrint("Should not be n: " + String(lastHit))
            lastHit = "n"
            debugPrint("hit top of net")
        }
        
        //If hits left side of net
        if ball.frame.origin.x + ball.frame.width > net.frame.origin.x && ball.frame.origin.x + ball.frame.width/4 < net.frame.origin.x && ball.frame.origin.y + ball.frame.height > view.frame.height - net.frame.height && lastHit != "n" {
            deflection(90, multiplier: CGFloat(0.8))
            debugPrint("Should not be n: " + String(lastHit))
            lastHit = "n"
            debugPrint("hit left of net")
        }
        
        
        //If hits right side of net
        if ball.frame.origin.x < net.frame.origin.x + net.frame.width && ball.frame.origin.x > net.frame.origin.x && ball.frame.origin.y + ball.frame.height > view.frame.height - net.frame.height && lastHit != "n" {
            deflection(90, multiplier: CGFloat(0.8))
            debugPrint("Should not be n: " + String(lastHit))
            lastHit = "n"
            debugPrint("hit right of net")
        }
        
        

        
        
        //If hits left wall
        if ball.frame.origin.x <= 0 && lastHit != "lw" {
            deflection(CGFloat(90), multiplier: CGFloat(0.8))
            lastHit = "lw"
            debugPrint("hit left wall")
        }
        
        //If hits right wall
        if ball.frame.origin.x + ball.frame.width >= view.frame.width && lastHit != "rw" {
            deflection(CGFloat(90), multiplier: CGFloat(0.8))
            lastHit = "rw"
            debugPrint("hit right wall")
        }
        
        
        //If the ball hits the edge of redSlime
        if (distance(redSlime.frame.origin.x + redSlime.frame.width/2, y1: view.frame.height, x2: ball.frame.origin.x + ball.frame.width/2, y2: ball.frame.origin.y + ball.frame.width/2) < redSlime.frame.width/2 + ball.frame.width/2 + 5 && lastHit != "r") {
            
            i = i + 1
            debugPrint("hit red slime" + String(i))
            hitspot = ((ball.frame.origin.x + ball.frame.width/2) - (redSlime.frame.origin.x + redSlime.frame.width/2))
            hitspot = hitspot/(redSlime.frame.width/2 + ball.frame.width/2) //116
            
            surfangle = (asin(Double(-hitspot)) * (180.0/M_PI))
            deflection(CGFloat(-surfangle), multiplier: CGFloat(1.1))
            
            lastHit = "r"
        }
        
        //IIf the ball hits the edge of blueSlime
        if (distance(blueSlime.frame.origin.x + blueSlime.frame.width/2, y1: view.frame.height, x2: ball.frame.origin.x + ball.frame.width/2, y2: ball.frame.origin.y + ball.frame.width/2) < blueSlime.frame.width/2 + ball.frame.width/2 + 5 && lastHit != "b") {
            
            i = i + 1
            debugPrint("hit blue slime" + String(i))
            hitspot = ((ball.frame.origin.x + ball.frame.width/2) - (blueSlime.frame.origin.x + blueSlime.frame.width/2))
            hitspot = hitspot/(blueSlime.frame.width/2 + ball.frame.width/2) //116
            
            surfangle = (asin(Double(-hitspot)) * (180.0/M_PI))
            deflection(CGFloat(-surfangle), multiplier: CGFloat(1.1))
            
            lastHit = "b"
            
        }
        
        
            
        //Move blue right
        if blueSlime.frame.origin.x + blueSlime.frame.width < view.frame.width && bGoingRight {
            blueSlime.frame.origin.x += moveSpeed
        }
            
        //Move blue left
        if  blueSlime.frame.origin.x > view.frame.width/2 + net.frame.width/2 && bGoingLeft {
            blueSlime.frame.origin.x += -1 * moveSpeed
        }
            
        //Move red right
        if redSlime.frame.origin.x + (redSlime.frame.width) < view.frame.width/2 - net.frame.width/2 && rGoingRight {
            redSlime.frame.origin.x += moveSpeed
        }
            
        //Move red left
        if redSlime.frame.origin.x > 0 && rGoingLeft {
            redSlime.frame.origin.x += -1 * moveSpeed
        }
        
    }
    

}

