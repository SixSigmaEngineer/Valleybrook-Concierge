# Valleybrook Concierge

A touchscreen kiosk app for the Project EARTH workshop at ETSU's Eastman Valleybrook campus (Building V2, Lower Level).

- **Interactive floor plans.** Three ETSU floor plan sheets (F1, F1 Workshop, F2), each on its own tab, with tappable bubbles for tools and resources.
- **Voice concierge.** Tap the mic and ask where something is. It answers out loud and highlights the spot on the map. It works offline with keyword matching, or with Claude if you add an Anthropic API key in ⚙︎ Settings.
- **Knowledge base.** Includes emergency procedures, exits and facilities contacts. You can edit it in ⚙︎ Settings → 📚 Knowledge base.
- **🚨 Emergency button.** Shows emergency phone numbers and step-by-step procedures.

## Run it
Open `index.html` in **Chrome or Edge**, which voice input needs. Press **F11** for full-screen kiosk mode.

## Folder layout
```
index.html               the whole app
maps/                    floor plan images shown on the map tabs
upload-to-github.bat     double-click to sync with this repo
photos/
  floor-plan/            photos of the posted floor plan
  signs/                 emergency and facilities signs
  equipment/             photos of workshop tools and equipment (add yours here)
```

## Working as a team
1. Install [Git for Windows](https://git-scm.com/download/win) if you don't have it.
2. The repo owner adds you as a collaborator on GitHub (Settings → Collaborators).
3. Put this folder on your computer and double-click **`upload-to-github.bat`**. It:
   - sorts any loose photos into `photos/`
   - saves your changes, pulls teammates' latest changes, then uploads
   - opens a browser the first time so you can sign in to GitHub

Run it **before** you start working, to get the latest version, and **after** you finish, to share your changes.

## Note on edits made inside the app
Bubble positions, descriptions, uploaded photos and knowledge base edits made in the app are saved in that browser only. To share them, go to ⚙︎ Settings → **Export data** and save the `.json` file into this folder before syncing. Teammates can load it with **Import data**.
