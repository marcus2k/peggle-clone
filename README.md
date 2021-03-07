# Peggle Clone

## Introduction
This app is a clone of the Peggle game, which includes a Physics Engine created from scratch. It was built using Swift 5 and SwiftUI 2.0 framework, and largely follows the MVVM architecture.

## Basic Gameplay Guide

* Select a saved Level you would like to play, which will lead you to the Level Designer. You may also create a new Level.
* Add by selecting item-type in the bottom-left portion of the palette before tapping on the game board.
    * Item-types include blue peg, orange peg, green peg (power up peg), grey peg (mystery peg), and rectangular block.
    * Items will not be added if it causes overlapping with other items
* Edit an item by selecting "setting" button before tapping on the item you wish to edit. 
Then select the property you wish to edit (angle, radius, width, or height) and drag the slider to the desired value.
    * Edit will fail if editing causes overlapping.
* Delete an item
    * Long press an item to delete it
    * Press the "reverse" button and tap on all items you want to delete.
* Saving the level
    * Ensure that the Level has a valid name.
    * Press save.
        * Saving will fail if Level Name is invalid.
* Power Up (Green Peg)
    * If a power up is selected prior to start of game, power up will be activated when green peg is hit.
        * If spooky ball power up was selected and green peg was then hit: when ball falls down, it should reappear on top.
           * Once ball is revived, power up is deactivated and subsequent exiting will not work unless another green peg is then hit.
           * Hitting > two green pegs in a single shot will only activate THIS power up once!
        * If space blast selected and green peg was then hit: nearby pegs lighten up.
           * Can activate multiple green pegs (power ups) in a single shot!
        * If no power up, none of the above should be observed.
* Mystery Pegs (Grey Pegs)
    * In the level designer, user can add mystery grey pegs. These pegs are uncoloured pegs that contain a hidden color. 
    The hidden color is randomly initialized each time the game is loaded.
    * The first hit to the peg will reveal its color, and ONLY the next hit will light it up. Furthermore, 
    all GREY pegs that have **orange** hidden color MUST be cleared in order to win. Upon completion of game,
    all hidden colors are revealed. If player loses, this informs player which of the grey pegs are orange that they missed.
    If player wins, it just reveals all blue / green for satisfaction of player.
    * Upon loading a game, the hidden color will be assigned at 50% probability of orange, 46% probability of blue, 
    and 4% probability of green (extremely lucky). As mentioned, player must clear all orange pegs INCLUDING 
    grey pegs that have HIDDEN orange color.
* Playing the level
    * Press start to play the level
    * Perform a drag gesture from the cannon to the direction you want the initial velocity to be set to.
        * Only one ball can be in the scene each time.
    * You win once all orange pegs are cleared within the limit of 10 shots. Else, you lose.


