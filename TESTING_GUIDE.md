# Testing Guide for Flutter Frontend

## Prerequisites

1. Install Flutter SDK (3.0 or later)
2. Have Chrome browser installed for web testing

## Setup

```bash
cd frontend
flutter pub get
```

## Running the Application

### Development Mode (Hot Reload)

```bash
cd frontend
flutter run -d chrome
```

This will:
- Open the app in Chrome
- Enable hot reload for quick testing
- Connect to the backend API at https://poker-backend-q18i.onrender.com

### Production Build

```bash
cd frontend
flutter build web --release
```

The built files will be in `frontend/build/web/`

## Manual Testing Checklist

### 1. Theme and Visual Design

- [ ] App bar shows casino chip icon and "Texas Hold'em Poker" in gold
- [ ] Background is dark green (poker table color)
- [ ] Tab bar shows three tabs with icons and gold indicators
- [ ] All cards have white background with rounded corners
- [ ] Hearts and Diamonds are displayed in RED
- [ ] Spades and Clubs are displayed in BLACK
- [ ] Buttons are gold with proper elevation

### 2. Card Selection - Basic Functionality

- [ ] Empty card slots show a "+" icon
- [ ] Clicking empty card slot opens the card selector dialog
- [ ] Card selector shows all 52 cards organized by suit
- [ ] Card selector has Hearts, Diamonds, Clubs, Spades sections
- [ ] Each suit shows 13 cards (A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, 2)
- [ ] Clicking a card in selector selects it and closes dialog
- [ ] Selected card appears as visual card in the slot
- [ ] Clicking a filled card slot opens the selector again

### 3. Card Selection - Disabled Cards

- [ ] Select a card (e.g., Ace of Hearts)
- [ ] Open another card slot selector
- [ ] Verify Ace of Hearts is grayed out and not clickable
- [ ] Select another card
- [ ] Open first slot selector
- [ ] Verify both cards are now disabled in both selectors
- [ ] Verify only selected cards are disabled (48 other cards still available)

### 4. Card Selection - Clear Functionality

- [ ] Select a card in any slot
- [ ] Click on that filled slot to reopen selector
- [ ] Click "Clear Selection" button
- [ ] Verify card is removed and slot shows "+" again
- [ ] Verify cleared card is now available in other selectors

### 5. Evaluate Tab - Load Example

- [ ] Click "Load Example" button
- [ ] Verify Player Card 1 = K♠ (King of Spades)
- [ ] Verify Player Card 2 = A♣ (Ace of Clubs)
- [ ] Verify Community Card 1 = 6♦ (Six of Diamonds)
- [ ] Verify Community Card 2 = 9♠ (Nine of Spades)
- [ ] Verify Community Card 3 = 4♥ (Four of Hearts)
- [ ] Verify Community Card 4 = 3♠ (Three of Spades)
- [ ] Verify Community Card 5 = 2♣ (Two of Clubs)

### 6. Evaluate Tab - Evaluation

- [ ] With example loaded, click "EVALUATE HAND"
- [ ] Verify loading spinner appears during API call
- [ ] Verify result card appears with trophy icon
- [ ] Verify hand rank name shown in large gold text
- [ ] Verify "Best Hand:" label appears
- [ ] Verify 5 best cards displayed as visual card thumbnails
- [ ] Verify result has dark background with gold accents

### 7. Evaluate Tab - Custom Selection

- [ ] Clear all cards
- [ ] Select custom cards of your choice
- [ ] Verify you can select exactly 7 cards total
- [ ] Try to evaluate with missing cards - verify error message
- [ ] Complete all 7 cards and evaluate successfully

### 8. Compare Tab - Load Example

- [ ] Switch to Compare tab
- [ ] Click "Load Example" button
- [ ] Verify Player 1 Card 1 = Q♦ (Queen of Diamonds)
- [ ] Verify Player 1 Card 2 = 2♣ (Two of Clubs)
- [ ] Verify Player 2 Card 1 = 10♣ (Ten of Clubs)
- [ ] Verify Player 2 Card 2 = 4♣ (Four of Clubs)
- [ ] Verify Community cards = Q♥, Q♠, 10♥, 10♦, 3♣

### 9. Compare Tab - Comparison

- [ ] With example loaded, click "COMPARE HANDS"
- [ ] Verify loading spinner appears
- [ ] Verify winner announcement card appears with trophy icon
- [ ] Verify winner text (e.g., "Player 1 Wins!" or "Player 2 Wins!")
- [ ] Verify Player 1 result card (green if winner, red if loser)
- [ ] Verify Player 2 result card (green if winner, red if loser)
- [ ] Verify each player shows:
  - Hand rank name
  - 5 visual card thumbnails
  - Checkmark icon for winner

### 10. Compare Tab - Tie Scenario

- [ ] Set both players with same cards (e.g., A♠, K♠ each)
- [ ] Set community cards to make best hand for both
- [ ] Compare hands
- [ ] Verify "It's a Tie!" message
- [ ] Verify neither card is green/red (both neutral)

### 11. Monte Carlo Tab - Load Example

- [ ] Switch to Monte Carlo tab
- [ ] Click "Load Example (Pocket Aces)" button
- [ ] Verify Player Card 1 = A♥ (Ace of Hearts)
- [ ] Verify Player Card 2 = A♠ (Ace of Spades)
- [ ] Verify all community card slots are empty
- [ ] Verify "Number of Players" slider shows 4
- [ ] Verify "Simulations" slider shows 10000

### 12. Monte Carlo Tab - Simulation

- [ ] With example loaded, click "RUN SIMULATION"
- [ ] Verify loading spinner appears (may take several seconds)
- [ ] Verify results card appears with insights icon
- [ ] Verify "Simulation Results" title in gold
- [ ] Verify three progress bars:
  - Win probability (green bar)
  - Tie probability (orange bar)
  - Loss probability (red bar)
- [ ] Verify percentages add up to ~100%
- [ ] Verify percentages match bar lengths

### 13. Monte Carlo Tab - Parameter Changes

- [ ] Change "Number of Players" slider to different values (2-10)
- [ ] Change "Simulations" slider to different values (1000-100000)
- [ ] Run simulation with different parameters
- [ ] Verify results update accordingly
- [ ] Test with community cards added (should affect probabilities)

### 14. Responsive Design - Desktop

- [ ] Resize browser window to various widths (1920px, 1280px, 1024px)
- [ ] Verify layout adjusts properly
- [ ] Verify cards wrap nicely in smaller widths
- [ ] Verify all text remains readable
- [ ] Verify buttons remain accessible

### 15. Responsive Design - Mobile

- [ ] Open Chrome DevTools (F12)
- [ ] Toggle device toolbar (Ctrl+Shift+M)
- [ ] Select various mobile devices (iPhone, iPad, etc.)
- [ ] Test portrait and landscape orientations
- [ ] Verify card selector dialog fits on screen
- [ ] Verify all elements are touchable (not too small)
- [ ] Verify scrolling works smoothly

### 16. Error Handling

- [ ] Try to evaluate/compare with incomplete cards - verify error message
- [ ] Disconnect internet and try API call - verify error handling
- [ ] Try invalid number of players (outside 2-10) - verify validation
- [ ] Try very large simulation numbers - verify it handles them

### 17. Visual Consistency

- [ ] Verify all gold colors match (#D4AF37)
- [ ] Verify all dark green backgrounds match (#0A5F38)
- [ ] Verify all card backgrounds are white/cream
- [ ] Verify all rounded corners are consistent
- [ ] Verify all shadows and elevations look professional

### 18. Unicode Symbols

- [ ] Verify ♠ (Spade) displays correctly in black
- [ ] Verify ♥ (Heart) displays correctly in red
- [ ] Verify ♦ (Diamond) displays correctly in red
- [ ] Verify ♣ (Club) displays correctly in black
- [ ] Verify symbols are large and clearly visible

### 19. Performance

- [ ] Card selector opens quickly (< 0.5 seconds)
- [ ] Card selection feels instant
- [ ] API calls complete reasonably (< 5 seconds)
- [ ] Monte Carlo with 100,000 simulations completes (may take 10-30 seconds)
- [ ] UI remains responsive during calculations

### 20. Cross-Browser Testing (Optional)

If time permits, test in other browsers:
- [ ] Firefox
- [ ] Safari
- [ ] Edge

## Common Issues and Solutions

### Issue: Flutter not installed
```bash
# Install Flutter from https://flutter.dev/docs/get-started/install
```

### Issue: Dependencies not found
```bash
cd frontend
flutter pub get
```

### Issue: Chrome not found
```bash
flutter config --enable-web
flutter devices  # Should show chrome
```

### Issue: CORS errors
- The backend is configured to allow all origins
- If you see CORS errors, check the backend API is running

### Issue: API timeout
- The backend might be cold-starting (first request takes longer)
- Try again after 10-20 seconds

## Expected Results

### Evaluate Tab Example (Row 2 - High Card)
- Result: "High Card"
- Best Hand: A♣, K♠, 9♠, 6♦, 4♥

### Compare Tab Example (Row 44 - Full House)
- Winner: Player 1
- Player 1: Full House (Three Queens, Two Tens)
- Player 2: Full House (Three Tens, Two Queens)

### Monte Carlo Example (Pocket Aces)
- Win probability: ~40-45% (varies due to randomness)
- Tie probability: ~2-5%
- Loss probability: ~50-55%

## Screenshots to Take

After testing, take screenshots of:

1. Evaluate tab with empty cards
2. Card selector dialog showing all suits
3. Evaluate tab with example loaded
4. Evaluate tab showing results
5. Compare tab with example loaded
6. Compare tab showing winner results
7. Monte Carlo tab with example loaded
8. Monte Carlo tab showing probability bars
9. Mobile view (vertical orientation)
10. Mobile view (horizontal orientation)

## Reporting Issues

If you find any issues during testing:

1. Note the exact steps to reproduce
2. Take a screenshot
3. Check browser console for errors (F12 → Console tab)
4. Note which browser and OS you're using
5. Report with all details above

## Success Criteria

The redesign is successful if:

✅ All visual elements match the poker theme (dark green, gold)
✅ Card selection works intuitively without typing
✅ All 52 cards display correctly with proper colors
✅ Example buttons load correct test data
✅ API calls work and results display beautifully
✅ Winner/loser colors are clear and helpful
✅ Mobile view is usable and attractive
✅ No console errors during normal use
