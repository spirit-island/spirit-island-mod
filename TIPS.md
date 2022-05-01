### Intro
- For the most part, the only things automated by the mod are Time Passes and Setup (not including the Initial Explore and Spirit Setup)
- It is not recommended to use the Rewind / Fast Forward Buttons (they often break scripted mods)
- Aspects of this mod may not match with the printed version as it aims to stay updated with errata (printed or not)
  - E.g. The Blight Card has 1 more Blight on it during Setup (https://querki.net/u/darker/spirit-island-faq/#!one-more-blight-errata)
- To use beta versions of the mod:
  - Download the TTS save from the pinned messages in #tabletop-simulator-mod channel (https://discord.gg/G84zRCrJZa)
  - Place that save file at: My Documents/My Games/Tabletop Simulator/Saves
  - Load the save:
    - Open a lobby in TTS
    - "Games" (top of the screen) &gt; "Save & Load" &gt; click the save file &gt; "Load"

### Troubleshooting
- Some objects are not loading (appearing white or yellow and black)
  - Go to Menu &gt; Configuration &gt; General and uncheck "Mod Caching" &gt; reload the Mod
  - Optionally you can turn Mod Caching back on (this will decrease load times in the future)
- The mod gets stuck at a certain % when loading
  - You've run out of memory. While TTS minimum is 4GB, the Spirit Island mod requires more than this, 8GB advised. If you've got less than 4GB ram, or are playing on a 32-bit operating system, you cannot play this mod.
- An Island Board is rotated/sized incorrectly for some players
  - The player(s) with the issues should reconnect, or
  - A player without the issues should use the Gizmo Tool (F8) and change the position/rotation/scale of the effected Island Board(s) by +0.01

## Overview
### TTS Beginners
- There are 10 default keybindings (using Num 0 - 9)
  - These are outlined in the Notes (lower right of the screen)
- To look at the underside of your Spirit Panel (for the setup instructions):
 - Hover + Alt + Shift
- To look at a card
 - Hover + Alt
- To mark a piece as Damaged: change its state
  - Hover + Page Up/Down to Increase/Decrease Damage
  - Hover + a num row key (0 Damage is state 1, 1 Damage is state 2, etc.)
- To mark a land as Defended
    - Use your respective Player's Defend Token (found next to the Elements above your Play Area)
    - Change its state to show a specific number
        - To set a double digit state: hover + two numbers in quick succession)
- To make a Sacred Site
  - Stack your Presence, or
  - Set the Presence to state 2 (for Spirits who have others ways of making Sacred Sites, e.g. Rivers Surges in Sunlight)
- To Remove a piece
  - Drop it on the Ocean playmat to Removes the piece
- To Destroy a piece
  - Remove it and manually Generate Fear, or
  - Drop it on a Destroy bag (found in the Box, at the top left of the table)
- To Forget a Power Card
  - Right click &gt; "Forget"
  - Forgotten Cards are located in the Box
- To Discard a Power Card
  - Right Click &gt; "Discard (to 2nd hand)"
  - Cards in Play are automatically Discarded during Time Passes
  - Discarded Cards are located just behind your hand
- To rebind scripted keybindings or bind additional functionality
  - Options &gt; Game Keys

### Spirit Island Beginners
- To simplify the setup UI: Uncheck "Advanced Settings"
- When choosing a Spirit, it is recommended:
  - To not use Aspects: Click "Aspects: All" so it shows "Aspects: None", and
  - To use the Progression Deck: Click "Progression: No" so  it shows "Progression: Yes"
- To use the Player Aid cards: "Show Player Aids" (upper right of the table) and optionally Unlock (Hover + L) and move them

### In Each Play Area There Is...
- A bag of Defend Tokens
  - These have a state for the various defend values
  - The backside of this token is the generic player marker
- A bag of Isolate Tokens
  - The backside of this token is the generic player marker
- A bag for each of the 8 Elements
  - With 0's underneath them, tracking what Elements you currently have (from Cards and/or Presence Tracks)
- A bag of "Any" Elements
  - These have a state (from 1 - 8) for each Element
  - Can be used when an "Any" is revealed on your Presence Tracks
- An "Energy Cost: 0"
  - Tracking the total Energy Cost of all Power Cards you have in Play
- A Digital Counter
  - Tracking how much Energy you have
- A "Gain" Button
  - Clicked to Gain Energy equal to the highest number on your Energy Track (excluding Energy from Growth options), or
  - Right-clicked to undo gaining that Energy
- A "Pay" Button
  - Clicked to Pay Energy equal to the total Energy Cost (mentioned above), or
  - Right-clicked to undo paying that Energy
- A Ready Token (with a red X on it)
  - When flipped (Hover + F, or click the UI in the top right) shows a green 🗸
  - When all are flipped, the turn progresses to the next Phase

### UI Elements (Toggleable in the Top Right):
- "Core Buttons"
  - "Gain a Major"
    - Reveals 4 Major Powers Cards, which you Gain 1 of by pressing "Pick Power"
  - "Gain a Minor"
    - The same as "Gain a Major" but with Minor Power Cards
  - "Time Passes"
    - Cleans things up for the next turn (see the Time Passes section for more detail)
  - A Ready Token
    - Serves as a reminder of if you have already flipped your ready token
    - Flips your Ready Token
- "Invader Board"
  - A tracker of how much Blight is currently remaining on the Blight Card
  - A tracker of how much Earned/Unearned Fear there is
    - Can be clicked to Add/Remove Fear from the Earned Fear Pool
  - A tracker of the Invader Cards in each Invader Step and the current Invader Stage
    - Any Steps which have been modified by an Adversary will have a bold black outline
    - "Stage" can be clicked to reveal the top Invader Card
    - "Explore" (visible when an Explore Card is revealed) can be clicked to Advance Invader Cards
- "Adversary"
  - A reminder of the Escalation Effect and Additional Loss Conditions
    - The Kingdom of France (Plantation Colony), The Habsburg Monarchy (Livestock Colony), and The Tsardom of Russia will also have additional information tracking their loss counter
    - When playing with 2 Adversaries, where the Supporting Adversary is The Kingdom of France (Plantation Colony) or The Kingdom of Sweden, there is a "Random" button
      - Which is intended to be used whenever there is a Stage III Escalation (see https://querki.net/u/darker/spirit-island-faq/#!.7w4gecx)
  - A reminder of each Adversary Level Effect currently in Play (Levels which only affect Setup are not included)
  - You can hover over any effect to see the full text on the Adversary Card
- "Turn Order"
  - An outline of the Phases of the Game
  - The current Phase of the Game is surrounded by &gt;&gt; &lt;&lt;
  - The Phase changes when by clicked in this UI, or when all Ready Tokens are flipped to the green side
- "Seat Controls"
  - Toggles buttons in each Player's play area
  - "Swap Place":
    - Will move your Spirit Panel and Hand/Discarded cards to the area the button is in
  - "Play [Color]/Spirit"
    - Will make you functionally become that player
  - "Swap [Color]"
    - Will make you and all your Presence / Reminder Markers the color of the button
- "Game Results"
  - Clicked to show the Game Results screen, as well as refreshing the current game state shown on that screen
  - Only visible when the game is either Won or Lost, and a game results screen will be shown automatically
  - "X"
    - Closes the screen
  - "Sacrifice?"
    - Should be pressed when the end of the action tree results in both a Victory and Loss
  - "Reset?"
    - Should be pressed if victory or loss condition was accidentally triggered

### Time Passes
- Heals all Invaders/Dahan
- Removes all Reminder Markers
- Discards all Powers Cards
- Removes all Element Markers
  - "Any" Element Markers will be reset back to the "Any" state if that state is locked
- To prevent something being affected by Time Passes: Lock it (Hover + L)

### Additional Notes
- There are trackers to help the players (to the right of the Invader Board)
  - Showing the summed total of Elements that players have (needed for "Aided By..." Events), and
  - Which players are ready to progress on to the next Phase of the turn
- There are randomisers
  - For the Spirits (in the upper right of the table)
    - Specific Complexities or Expansions can be toggled
  - For the Adversary / Scenario / Board Layout (in their respective drop down menus)
    - A Difficulty range should be specified when randomizing Adversary/Scenario
- To play with more Spirits than players:
  - Choose a Spirit
  - Press the "Play [Color]" Button in front of a different seat
  - Choose a Spirit
  - To easily swap between Spirits during Play: "Play Spirit" (below the Spirit Panel of Spirits without Players)
- To grab Spirit Markers: right-click (anywhere) &gt; "Grab Spirit Markers"
- To Play with a Custom/Archipelago Board Layout
  - Click "Hide UI"
  - Take out however many Island Boards you want from the Box (found in the top left on the table)
  - Place them on the Ocean playmat
  - Click "Start Game"
- To play with "Larger Island" rules (one more Island Board than players)
  - Check "Variant Rules" &gt; Check "Add an extra Island Board"
  - A message will appear after Setup stating which Board is the 'extra' one, which should not be set up on
- If you have chosen a Spirit you do not want to play, reload the mod
- To play with Energy Tokens (instead of the counter): unlock (L) / delete the pre-existing counter
  - Tokens will now be given by the "Gain" button, and used by the "Pay" button
  - Adding 1/3 Energy Tokens can be bound

### Specific Effects
- Some Event/Fear/Power Cards have buttons on them
  - This is to automate tasks such as: grabbing Reminder Cards, returning Events to the Event Deck, removing Invader Cards from the Invader Deck, etc.
  - To use Cast Down into the Briny Deep's Button: place the Power Card on the Island Board you are Destroying &gt; "Destroy Board"
- To prevent an Invader Card from advancing this turn (for Immigration Slows): Lock (Hover + L) that Invader Card
- To reveal multiple Explore Cards (for Explorers are Reluctant): "Explore" &gt; Lock (Hover + L) that Explore Card &gt; "Explore"
- To increase/decrease the amount of Fear in the Fear Pool (not generating Fear): Left/Right click "Modify Fear Pool" (on the Invader Board)
- To choose from 2 Major Power Cards (for Unlock The Gates of Deepest Power): right-click "Gain a Major"
- To choose from 6 Minor Power Cards (for Boon of Reimagining): right-click "Gain a Minor"
- To choose 2 Power Cards when gaining them (for Fractured or Boon of Reimagining): right-click "Pick Power" on the first Power Card
- To choose 2 Power Cards when gaining them (for Entwined Power): have the other Player click "Pick Power" first
- To prevent Invaders/Dahan from healing during Time Passes (for Shroud of a Silent Mist): lock (Hover + L) them (or if they are stacked, lock the bottom piece in the stack)
- To Drown Invaders/Dahan (for Ocean's Hungry Grasp)
  - Drop them onto the Drowning Bag
  - Fear will automatically be added
  - By default Energy will automatically be converted when enough Health of Invaders have been Drowned
    - You can disable this by untoggling "Auto Energy"
- To track Powers which have been made Fast (for Lightning's Swift Strike)
  - Drop a Speed Token from the bag onto the power card
  - If playing with the Blitz Scenario this will also automate Power Card's having a lower Energy Cost
- To track Element Markers (for Shifting Memory of Ages)
  - These Element Markers do not increase your total Elements (because they only give you Elements for a single Action)
  - When using Elemental Teachings make sure to trade them out for actual Element

### Second Wave
- After finishing the first game
  - Follow the "After the First Game" instructions on the Second Wave Scenario Card
    - Any set aside Power Cards should be placed in the brown bag provided (above the Scenario Card)
  - Click "Export Config" (on the Scenario Card)
  - Copy the Config from the Notebook
  - Make note of where pieces are on the island
    - Via screenshot, notes, or selecting all pieces &gt; right-click &gt; "Save Object"
- Load the Mod
  - Paste the copied Config into Notebook
  - Choose Spirits
  - Click "Start Game"
  - Manually add the pieces back to the island
    - Based on screenshot, notes, or loading them in as a Saved Object ("Objects" &gt; "Saved Objects")

### Custom-made Content Notes
- To load in custom-made content (if it is a workshop mod): "Games" (top of the screen) &gt; "Workshop" &gt; "..." &gt; "Additively Load"
- To load in a saved object: "Objects" (top of screen) &gt; "Saved Objects"
- To give custom Power/Blight Cards appropriate features (Elements, Energy Cost, Threshold, etc.)
  - "Show Editors" (top right of the table) &gt; Hover over the appropriate tile for more instructions
  - Likewise, to give custom Spirit Panels the appropriate Elements/Thresholds
  - For more details on custom-made content, visit https://github.com/spirit-island/spirit-island-mod/blob/beta/CUSTOM.md
