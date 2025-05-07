# 🎨 **Real Time Drawing and Guessing Game** 

*A multiplayer drawing and guessing game with real-time synchronization, chat, and competitive gameplay*

---

## 🚀 **Features**  

### 🖌️ **Core Gameplay**  
- **Real-time synchronized drawing canvas** with smooth brush strokes  
- **Multiplayer guessing system** with instant feedback  
- **Turn-based gameplay** with automatic player rotation    

### ⏱️ **Game Flow**  
- **Animated progress bar** representing time left for guessing the correct word.
- **Automatic round progression** (Drawing → Guessing )  
- **Instant round transitions** with smooth animations  

### 💬 **Social Features**  
- **Real-time chat** with:  
  - Text messages  
  - Emoji reactions  
  - Correct Guess highlight  
  

---

## 🖥️ **Tech Stack**  

| Component        | Technology |
|-----------------|------------|
| Frontend        | Flutter(StreamBuilder,Canvas,etc) |
| Backend         | Golang (Go) |
| Real-Time       | nhooyr.io/websocket |

---

## 🎮 **Game Flow Diagram**  

```mermaid
graph TD
    A[Player Login] --> B[Lobby]
    B --> C{Game Start}
    C --> D[Word Selection]
    D --> E[Drawing Phase]
    E --> F[Guessing Phase]
    F --> G[Break]
    G --> H{Next Round?}
    H -->|Yes| D
    H -->|No| I[Game Over]
