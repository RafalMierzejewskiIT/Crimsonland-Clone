## Crimsonland Clone

This is a clone of the game Crimsonland made using LÖVE2D. <br/>

The goal of this game is to achieve the highest score possible by eliminating monsters. <br/>

### Controls

1 = Pistol
2 = SMG

WSAD = Movement
LMB = Shooting

Escape = Pause/Unpause

## About the project

This is my project for CS50's Final Project. <br/>

Following the instructions of Guy White from one of the seminars in CS50, at first I tried to reduce the game down to its Minimal Viable Product, I determined that for this game it would be <br/>
Player character that moves in 8 direction <br/>
Player character should be able to shoot a bullet in the direction of the cursor <br/>
One enemy that moves towards the player character. <br/>

This approach was a curse and a blessing, a blessing because it gave me a working prototype very early on, and a curse because due to underlying architecture which worked only for one of everything needed some serious changing in order to expand on it. <br/>

So from one player, one enemy, one weapon which shoots one type of projectile, it expanded to one player character, with one of three possible enemies being spawned every second somewhere around the edge of the screen, two different weapons with distinct bullets, bullet trails, recoil, ammunition, reloading, health bar, score, menu, pause, volume control, Cursor showing ammo and recoil spread. <br/>

Almost everything in this game is part of the superclass Entity. <br/>
Cursor, Bullet and EntityHealth inherit from Entity. <br/>
Moveable inherits from EnemyHealth. <br/>
Player and Enemy inherit from EnemyHealth. <br/>
Weapons and BulletTrail are standalone classes. <br/>

A menu was added midway through development, and it was a bigger trouble than I anticipated it to be. <br/>
I put some extra work into them so they highlight when mouseovered, with each button having its own sound channel just so you can swipe across them satisfyingly! <br/>
Every button is an object with the same properties, I know I should make them a class already but the truth is that menu is a mess, and a decent implementation isn't worth pursuing for the scope of this game. <br/>
What buttons are present are part of an array which is being rendered, for example the main menu is called "Start", and for "Start" <br/>
`Buttons = { StartGameButton, Options, ExitButton }` <br/>
Every part of menu has its own name and associated buttons. <br/>

There's Start Game, Options and Exit buttons. <br/>

Inside Options you're able to change the volume with a slider made using simple-slider library created by [georgeprosser](https://www.love2d.org/forums/memberlist.php?mode=viewprofile&u=134865) from the [LÖVE2D Forums](https://www.love2d.org/forums/viewtopic.php?t=80711) <br/>

## Explaining the code

Upon clicking Start Game the Player Character is generated in the center of the screen made by taking half of the width and height of your current monitors resolution. <br/>

Some things that exist in most classes: <br/>

There's tons of timers related to something in my classes, for example `rate_of_fire` and `rate_of_fire timer`, the way they're being handled is I initialise them to their minimal or maximal possible value depending on the situation, and on every update its being checked if they're below 0. <br/>
if that's true, something happens and timer value is changed to their related property, in this case `rate_of fire`. So check `rate_of_fire_timer < 0`, then do stuff, and then `rate_of_fire_timer = rate_of_fire`. <br/>

When I need to remove something from memory or the screen I change this objects property delete to true. <br/>
In the main loop when I run update on every instance of an enemy, I check if their property delete is true, and remove them if that's true. <br/>
This is inefficient, but it's sufficient for my needs, and this is solution given by seminars reference sheepolution tutorial. <br/>
I tried to fix it to reduce the lines of code but the problem lies with table.insert not returning index in lua, I would need to keep track of the indices myself. <br/>
I'm not saying this is unsolvable but messy and possibly even more complicated than it seems depending on how arrays are implemented in lua. <br/>

When the user presses any key on the keyboard, it sends that input on every frame update which is usually 500 times a second. <br/>
Whenever I wanted to make a pause if player pressed escape it just switched on and off like crazy. <br/>
So when I need to receive input only once, I add a check 'if not InputCheck to "if love.[].isDown", do something in that block of code in case user pressed button I want AND InputCheck is false, after that I change InputCheck to love.[keyboard or mouse].isDown, now for every keypress I only get the input once. <br/>

### Player

Player is able to move in 8 directions, after some time I realised that player moves faster diagonally. <br/>
I solved this using pythagorean theorem, since a and b are 1, hypotenuse will be $`\sqrt{2}`$, so when dx and dy aren't 0, the movement speed of both axes is being multiplied by half of $`\sqrt{2}`$ which I round down to 0.7071. <br/>
Now Player moves diagonally with a speed of $`\frac{\sqrt{2}}{2}`$ on both axes, normalising the vector to 1. <br/>
Making this my first real use of pythagorean theorem in real life. <br/>

Around the player is a blue circle which indicates HP. It's an arc which takes values in radians so its calculated by dividing the current health by max health, taking that and multiplying by 2π, then subtracting $`\frac{π}{2}`$ to make it face the correct way which starts at right by default. <br/>

Player faces the cursor using the atan2 function which gives me relative angle between cursor and the player, the returned value is in radians, so I draw the player using this angle as its rotation parameter. <br/>

### Enemy

Somewhere around the edge of your screen an enemy is being spawned every 1 second. <br/>
It's a pseudorandom choice: <br/>
10% for a smaller, faster, enemy with 50 health that deals 10 damage every 0.5s. <br/>
80% for a medium enemy with 100 health that deals 20 damage every second. <br/>
10% for a bigger, slower enemy with 200 health that deals 30 damage every 1.5s. <br/>
The bigger and slower the enemy is, the darker its color. <br/>

For reference, Player Character speed is between medium and faster enemy, and has 100 health. <br/> <br/>

All of them move toward the Player character in a straight line. <br/>
It is being calculated by using atan2 function again for relative angle this time between player and the enemy, using this angle for sinus gives me vertical value, and cosinus gives me horizontal value of the movement vector. <br/>
Multiplying them in the movement formula: <br/>

```lua
self.x = self.x + self.speed * cos * dt
self.y = self.y + self.speed * sin * dt
```

Making this my first real use of trigonometry in real life. <br/>

### Weapons

Weapons are pretty straightforward, user selects their weapon by pressing 1 for pistol and 2 for smg, all of the weapons are being updated on every frame so you could get better accuracy if you switch your weapons dynamically. <br/>
Everything has a sound, firing, reloading, finishing reloading. <br/>
If ammo_current > 0 player will successfully fire, else the weapon will be reloaded to ammo_max. <br/>
When weapon fires it creates an instance of a Bullet class, passing speed and damage to its constructor. <br/>

### Bullet

Every bullet faces the direction of the cursor using previously described trigonometry, due to their high velocity my collision detection sometimes bullets skip the enemy when they shouldn't. <br/>
Taking the weapons current recoil status there's a pseudorandom diviation from the original angle. <br/>
Bullets are being deleted if they go off the screen or they collide with an enemy. <br/>

### Bullet Trails

On every bullet update an instance of BulletTrail class is being created, passing previous x, previous y, x, y, and trail_time. <br/>
Using this information I draw a line between previous xy and current xy. trail_time is being used to calculate how long the trail should exist. <br/>
The bullet increases trail_time by delta time with every update. trail_time is being passed to create a new instance of bullet trail for as long as the bullet exists. <br/>

BulletTrail has several distinct properties. <br/>
current = amount of time that has passed since creation of that BulletTrail instance. <br/>
This increases by delta time on every update. <br/>

time = how much time since creation of the bullet has passed. <br/>
duration = multiplier for how long should the trail last. <br/>
offset = amount of time during which extra frames at max brightness are being added. <br/>
max_brightness = value that is passed to all r,g and b components of the love.graphics.setColor() function, making it different shade of white. <br/>
Transparency should be used instead but since each point of the trails current xy is also being held by the next ones previous xy it gives brighter color at those points. Not sure how to solve it for now. <br/>

For as long as current > duration, the color will keep darkening, how fast depends on time property. <br/>
Formula for color was tricky to do. <br/>
color = ((duration - current) / dt / (time / dt)) \* max_brightness <br/>
The formula can be dense, so here's a step-by-step example: <br/>

#First update:
The effect of this formula is that the first bullet trail instance will have color of 1/1 of max_brightness. <br/>
#Second update:
First bullet trail instance dies, or it would if it weren't for the offset which we will ignore in this explanation. <br/>
Second bullet trail instance is being created with 2/2 of max_brightness., so 0.7 by default. <br/>
#Third update:
Second bullet trail will have color of 1/2 of max_brightness. <br/>
Third bullet trail instance is being created with 3/3 of max_brightness. <br/>
#Fourth update:
Second bullet trail instance dies. <br/>
Third bullet trail will have color of 1/3 of max_brightness. <br/>
Fourth bullet trail instance is being created with 4/4 of max_brightness. <br/>

Each bullet trail has a certain lifespan, which is determined by how much time has passed since creation of the bullet instance which spawned it. <br/>
Every next instance of bullet trail will have longer lifespan by one delta time more than the previous instance, making the trail longer the further away it is from the original xy of the bullet. <br/>
Additionally, an offset is applied to extend the lifespan of each bullet trail, adding a bit of time for how long each bullet trail exists, and during that time, their color is max_brightness. Without it first bullet trails would be too short and dark. <br/>

Without all that, trails that originate from Player character that have a flat duration will just leave sharp edge where Player shot from. <br/>
To make it look right it has to barely exist at all during shooting, increasing length with distance. <br/>
Everything has to create a sort of harmony within chaos, bullet trails starting with few offset max_brightness frames, long just enough to make the shooting pop, but also not long enough, allowing the changing of color to be fast enough so that the next trail will get enought contrast as to appear distinct from the previous shot. <br/>

Somewhat confusingly, BulletTrail is not a subclass of the Bullet class, this is because whenever bullet goes out of the screen it is being deleted, and alongside it, trail would vanish instantly. <br/>
I could create code to manage bullets based on a boolean value, but then I would need code to check if all trails of that bullet would finish their lifecycle, to do that bullets would need additional property, all that seemed just unnecessary compared to separating the two. <br/>

I must say, the impact of adding bullet trails was quite astonishing. After being done right, the game at that point really started to feel like a real game. <br/>

### Cursor

Cursor is being rendered wherever the mouse pointer... points, it's a small circle that also shows the recoil! <br/>
The recoil_current dictates the possible range of bullet angle deviation, but that is all relative to the distance, so using pythagorean theorem I calculate the distance, multiply it by recoil_current and I use this value as radius for the circle. <br/>
It also shows the remaining ammo in currently selected weapon. <br/>

### Main

I aimed to keep the main function as slim as possible. <br/>

In update function, there are only a few things, Pause logic, checking collision and running update on all instances of all classes and check if they should be deleted by checking their delete property. <br/>
Checking collision is done by checking if the distance between objects(which is calculated using pythagorean theorem) is smaller than the sum of both objects radii. <br/>

All of the deletions are run in reverse order to make sure they don't skip anything due to the way arrays indexing works. If I were to check let's say index 5, delete it, now index 5 contains another instance which might also have delete property set to true, but I skip it since now I change my index to 6. This is no longer an issue if we do it in reverse order. <br/>

Checking if the player has died and displaying Game Over menu if true. <br/>
Updating menu related stuff if we're in a menu. <br/>

In draw function, I just check what should be rendered, the game, the menu, or both. When rendering the game, I draw each instance of every class in the following order: Player, Bullet trails, Bullets, Enemies, Score, and Cursor. <br/>

I could be adding stuff to this game for the next month, but time flies and other projects need to be done. <br/>
It was very interesting to me how me having to write all that, made me reconsider and change so many things in my code due to inconsistency, or just plainly not making sense, or being redundant. <br/>
It was like rubberducking the whole source code, extremely insightful, the code stands on much more sturdy fundaments now, all of the changes made because of having to write all that will be in a PR called Rubberducking. Its quite a list. <br/>
