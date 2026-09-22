# Neovim Keymaps 🗺️

> **Leader key = `Space`** | **LocalLeader = `\`**
>
> Hinglish mein samjhaya gaya hai — taki bhai log bhi samjhein 😄

---

## 🧠 General

| Key          | Action                        | Kya karta hai                                      |
| ------------ | ----------------------------- | -------------------------------------------------- |
| `<leader>y`  | Copy to system clipboard      | Selection ko system clipboard mein copy karo (n/v) |
| `<leader>Y`  | Copy line to system clipboard | Poori line clipboard mein copy karo                |
| `<leader>x`  | Make file executable          | File ko executable banao (`chmod +x`) — Unix only  |
| `<leader>lw` | Toggle line wrap              | Line wrap on/off karo                              |
| `<leader>?`  | Show keymap cheatsheet        | Which-key se saare keymaps dikhao                  |
| `<leader>ev` | Open Neovim config            | Neovim config folder Neo-tree mein kholo           |
| `<leader>f`  | Format file                   | File ko format karo (conform.nvim)                 |

---

## 🔼 Navigation

| Key     | Action                 | Kya karta hai                                 |
| ------- | ---------------------- | --------------------------------------------- |
| `<C-d>` | Scroll down (centered) | Neeche scroll karo, cursor center mein rahega |
| `<C-u>` | Scroll up (centered)   | Upar scroll karo, cursor center mein rahega   |
| `H`     | Jump to line start     | Line ke pehle non-blank character pe jao      |
| `L`     | Jump to line end       | Line ke end pe jao                            |

---

## 🪟 Window Management

| Key          | Action                       | Kya karta hai                         |
| ------------ | ---------------------------- | ------------------------------------- |
| `<leader>v`  | Split vertically             | Window ko vertically split karo       |
| `<leader>h`  | Split horizontally           | Window ko horizontally split karo     |
| `<leader>se` | Equalize splits              | Saari split windows equal size kar do |
| `<leader>xs` | Close current split          | Current split window band karo        |
| `<C-h>`      | Move to left split           | Left wali window mein jao             |
| `<C-j>`      | Move to bottom split         | Neeche wali window mein jao           |
| `<C-k>`      | Move to top split            | Upar wali window mein jao             |
| `<C-l>`      | Move to right split          | Right wali window mein jao            |
| `<Up>`       | Resize split (shrink height) | Split ki height thodi kam karo        |
| `<Down>`     | Resize split (grow height)   | Split ki height thodi badhao          |
| `<Left>`     | Resize split (shrink width)  | Split ki width thodi kam karo         |
| `<Right>`    | Resize split (grow width)    | Split ki width thodi badhao           |

---

## 📄 Buffers & Tabs

| Key                | Action            | Kya karta hai                     |
| ------------------ | ----------------- | --------------------------------- |
| `<Tab>`            | Next buffer       | Agla buffer kholo                 |
| `<S-Tab>`          | Previous buffer   | Pichla buffer kholo               |
| `<leader>xb`       | Close buffer      | Current buffer band karo (split layout safe) |
| `<leader>to`       | New tab           | Naya tab kholo                    |
| `<leader>tc`       | Close tab         | Current tab band karo             |
| `<leader>tn`       | Next tab          | Agla tab pe jao                   |
| `<leader>tp`       | Previous tab      | Pichle tab pe jao                 |
| `<leader><leader>` | Find open buffers | Telescope se open buffers dhundho |

---

## 🌲 File Explorer (Neo-tree)

### Global Keymaps

| Key           | Action                | Kya karta hai                                |
| ------------- | --------------------- | -------------------------------------------- |
| `<leader>e`   | Toggle Neo-tree       | File explorer kholo/band karo                |
| `<leader>gf`  | Git status (floating) | Git status floating window mein dikhao       |
| `<leader>ngs` | Git status (floating) | Same as above (neo-tree plugin se)           |
| `\`           | Reveal current file   | Current file ko Neo-tree mein highlight karo |

### Neo-tree Window Keymaps (andar ke keys)

| Key             | Action                  | Kya karta hai                           |
| --------------- | ----------------------- | --------------------------------------- |
| `<space>`       | Toggle node             | Folder kholo ya band karo               |
| `<cr>` or `l`   | Open                    | File/folder kholo                       |
| `<2-LeftMouse>` | Open                    | Double click se kholo                   |
| `<esc>`         | Cancel                  | Preview ya floating window band karo    |
| `P`             | Toggle preview          | File ka preview float mein dikhao       |
| `S`             | Open in split           | Horizontal split mein kholo             |
| `s`             | Open in vsplit          | Vertical split mein kholo               |
| `t`             | Open in new tab         | Naye tab mein kholo                     |
| `w`             | Open with window picker | Window picker se kholo                  |
| `C`             | Close node              | Node band karo                          |
| `z`             | Close all nodes         | Saare nodes band karo                   |
| `a`             | Add file                | Naya file banao                         |
| `A`             | Add directory           | Naya folder banao                       |
| `d`             | Delete                  | File/folder delete karo                 |
| `r`             | Rename                  | File/folder rename karo                 |
| `y`             | Copy to clipboard       | File clipboard mein copy karo           |
| `x`             | Cut to clipboard        | File clipboard mein cut karo            |
| `p`             | Paste from clipboard    | Clipboard se paste karo                 |
| `c`             | Copy (with destination) | File copy karo destination choose karke |
| `m`             | Move                    | File move karo                          |
| `q`             | Close window            | Neo-tree band karo                      |
| `R`             | Refresh                 | Tree refresh karo                       |
| `?`             | Show help               | Help dikhao                             |
| `<`             | Previous source         | Pichla source (files/buffers/git)       |
| `>`             | Next source             | Agla source                             |
| `i`             | Show file details       | File ki details dikhao                  |

### Filesystem-specific (Neo-tree)

| Key     | Action               | Kya karta hai                      |
| ------- | -------------------- | ---------------------------------- |
| `<bs>`  | Navigate up          | Parent folder mein jao             |
| `.`     | Set root             | Is folder ko root banao            |
| `H`     | Toggle hidden files  | Hidden files dikhao/chhupao        |
| `/`     | Fuzzy finder         | Files fuzzy search karo            |
| `D`     | Fuzzy finder (dirs)  | Sirf directories fuzzy search karo |
| `f`     | Filter               | Filter lagao                       |
| `<c-x>` | Clear filter         | Filter hatao                       |
| `[g`    | Prev git modified    | Pichla git-modified file           |
| `]g`    | Next git modified    | Agla git-modified file             |
| `o`     | Order by (menu)      | Sorting menu kholo                 |
| `oc`    | Order by created     | Creation time se sort karo         |
| `od`    | Order by diagnostics | Diagnostics se sort karo           |
| `og`    | Order by git status  | Git status se sort karo            |
| `om`    | Order by modified    | Modified time se sort karo         |
| `on`    | Order by name        | Naam se sort karo                  |
| `os`    | Order by size        | Size se sort karo                  |
| `ot`    | Order by type        | Type se sort karo                  |

### Git Status Window (Neo-tree)

| Key  | Action              | Kya karta hai           |
| ---- | ------------------- | ----------------------- |
| `A`  | Git add all         | Saari files stage karo  |
| `ga` | Git add file        | Current file stage karo |
| `gu` | Git unstage file    | File unstage karo       |
| `gr` | Git revert file     | File revert karo        |
| `gc` | Git commit          | Commit karo             |
| `gp` | Git push            | Push karo               |
| `gg` | Git commit and push | Commit karke push karo  |

---

## 🔭 Telescope (Search)

### Normal Mode

| Key          | Action                    | Kya karta hai                          |
| ------------ | ------------------------- | -------------------------------------- |
| `<leader>sf` | Find files                | Project mein files dhundho             |
| `<leader>sg` | Live grep                 | Poore project mein text search karo    |
| `<leader>sw` | Grep current word         | Cursor ke neeche wala word search karo |
| `<leader>sh` | Search help tags          | Neovim help mein search karo           |
| `<leader>sk` | Search keymaps            | Saare keymaps search karo              |
| `<leader>ss` | Search Telescope builtins | Telescope ke saare pickers dikhao      |
| `<leader>sd` | Search diagnostics        | LSP diagnostics search karo            |
| `<leader>sr` | Resume last search        | Pichli search resume karo              |
| `<leader>s.` | Recent files              | Haal hi mein khule files dikhao        |
| `<leader>/`  | Fuzzy search in buffer    | Current buffer mein fuzzy search karo  |
| `<leader>s/` | Live grep in open files   | Sirf open files mein grep karo         |

### Inside Telescope Picker

| Key              | Action                  | Kya karta hai                     |
| ---------------- | ----------------------- | --------------------------------- |
| `<C-k>`          | Move to previous result | Upar wala result select karo      |
| `<C-j>`          | Move to next result     | Neeche wala result select karo    |
| `<C-l>`          | Open selected file      | Selected file kholo               |
| `<c-/>` (insert) | Show keymaps            | Telescope ke andar ke keys dikhao |
| `?` (normal)     | Show keymaps            | Telescope ke andar ke keys dikhao |

---

## 🧬 LSP (Language Server)

> Ye keymaps tab kaam karte hain jab LSP attached ho

| Key          | Action               | Kya karta hai                               |
| ------------ | -------------------- | ------------------------------------------- |
| `gd`         | Go to definition     | Variable/function ki definition pe jao      |
| `gr`         | Go to references     | Saari jagah dhundho jahan ye use hua hai    |
| `gI`         | Go to implementation | Implementation pe jao                       |
| `gD`         | Go to declaration    | Declaration pe jao (e.g. C header)          |
| `<leader>D`  | Type definition      | Variable ke type ki definition pe jao       |
| `<leader>ds` | Document symbols     | Current file ke saare symbols dikhao        |
| `<leader>ws` | Workspace symbols    | Poore project ke symbols search karo        |
| `<leader>rn` | Rename symbol        | Variable/function rename karo (saari jagah) |
| `<leader>ca` | Code action          | LSP se code fix/action lo (n/x)             |
| `<leader>th` | Toggle inlay hints   | Inlay hints on/off karo                     |

---

## 🩺 Diagnostics

| Key         | Action                 | Kya karta hai                   |
| ----------- | ---------------------- | ------------------------------- |
| `[d`        | Previous diagnostic    | Pichli error/warning pe jao     |
| `]d`        | Next diagnostic        | Agli error/warning pe jao       |
| `<leader>d` | Open diagnostic float  | Error ka popup dikhao           |
| `<leader>q` | Diagnostics to loclist | Saari errors loclist mein daalo |

---

## 🌿 Git (Fugitive)

| Key           | Action                       | Kya karta hai                                    |
| ------------- | ---------------------------- | ------------------------------------------------ |
| `<leader>gs`  | Git status                   | Git status window kholo                          |
| `<leader>gd`  | Git diff split               | Diff split mein dikhao                           |
| `<leader>gb`  | Git blame                    | Poori file ka blame dikhao                       |
| `<leader>gl`  | Git log                      | Git log dikhao                                   |
| `<leader>ga`  | Git add all                  | Saari changes stage karo                         |
| `<leader>gc`  | Git commit                   | Commit karo                                      |
| `<leader>gca` | Git commit --amend           | Last commit ka message edit karo                 |
| `<leader>gcf` | Git commit --amend --no-edit | Last commit mein changes add karo (message same) |
| `<leader>gp`  | Git push                     | Push karo                                        |
| `<leader>gP`  | Git pull                     | Pull karo                                        |
| `gu`          | Diffget //2 (ours)           | Merge conflict mein apna wala rakho              |
| `gh`          | Diffget //3 (theirs)         | Merge conflict mein unka wala rakho              |

### Fugitive Buffer (`:Git` window ke andar)

| Key         | Action             | Kya karta hai                |
| ----------- | ------------------ | ---------------------------- |
| `<leader>p` | Git push           | Push karo                    |
| `<leader>r` | Git pull --rebase  | Rebase ke saath pull karo    |
| `<leader>t` | Git push -u origin | Upstream set karke push karo |

---

## 🔥 Gitsigns (Hunk-level Git)

| Key          | Action              | Kya karta hai                           |
| ------------ | ------------------- | --------------------------------------- |
| `]c`         | Next hunk           | Agla git change pe jao                  |
| `[c`         | Previous hunk       | Pichla git change pe jao                |
| `<leader>hs` | Stage hunk          | Current hunk stage karo                 |
| `<leader>hr` | Reset hunk          | Current hunk reset karo                 |
| `<leader>hp` | Preview hunk        | Hunk ka diff preview dikhao             |
| `<leader>hd` | Diff this           | Current file ka diff dikhao             |
| `<leader>hS` | Stage buffer        | Poora buffer stage karo                 |
| `<leader>hR` | Reset buffer        | Poora buffer reset karo                 |
| `<leader>hU` | Unstage buffer      | Poora buffer unstage karo               |
| `<leader>hb` | Blame line (popup)  | Current line ka blame popup mein dikhao |
| `<leader>hT` | Toggle inline blame | Inline blame on/off karo                |

### Visual Mode (Gitsigns)

| Key          | Action               | Kya karta hai                      |
| ------------ | -------------------- | ---------------------------------- |
| `<leader>hs` | Stage selected hunks | Selected lines ke hunks stage karo |
| `<leader>hr` | Reset selected hunks | Selected lines ke hunks reset karo |

---

## ⚔️ Git Conflict (git-conflict.nvim)

> Default mappings enabled hain

| Key  | Action            | Kya karta hai          |
| ---- | ----------------- | ---------------------- |
| `co` | Choose ours       | Apna wala change rakho |
| `ct` | Choose theirs     | Unka wala change rakho |
| `cb` | Choose both       | Dono changes rakho     |
| `c0` | Choose none       | Koi bhi mat rakho      |
| `]x` | Next conflict     | Agla conflict pe jao   |
| `[x` | Previous conflict | Pichla conflict pe jao |

---

## 🤖 Autocompletion (nvim-cmp)

> Insert mode mein kaam karte hain

| Key         | Action                     | Kya karta hai                           |
| ----------- | -------------------------- | --------------------------------------- |
| `<C-n>`     | Next suggestion            | Agla completion item select karo        |
| `<C-p>`     | Previous suggestion        | Pichla completion item select karo      |
| `<C-y>`     | Accept completion          | Selected completion accept karo         |
| `<C-Space>` | Trigger completion         | Manually completion trigger karo        |
| `<C-b>`     | Scroll docs back           | Documentation window upar scroll karo   |
| `<C-f>`     | Scroll docs forward        | Documentation window neeche scroll karo |
| `<C-l>`     | Snippet jump forward       | Snippet ke agle placeholder pe jao      |
| `<C-h>`     | Snippet jump backward      | Snippet ke pichle placeholder pe jao    |
| `<Tab>`     | Next item / expand snippet | Agla item ya snippet expand karo        |
| `<S-Tab>`   | Previous item              | Pichla item select karo                 |

---

## 🗂️ Yazi (File Manager)

| Key          | Action                    | Kya karta hai                     |
| ------------ | ------------------------- | --------------------------------- |
| `<leader>yf` | Open Yazi at current file | Current file pe Yazi kholo        |
| `<leader>cf` | Open Yazi at cwd          | Working directory mein Yazi kholo |
| `<leader>ct` | Resume last Yazi session  | Pichli Yazi session resume karo   |

---

## ✏️ Visual Mode

| Key | Action            | Kya karta hai                                          |
| --- | ----------------- | ------------------------------------------------------ |
| `<` | Indent left       | Selection ko left indent karo (visual mode mein raho)  |
| `>` | Indent right      | Selection ko right indent karo (visual mode mein raho) |
| `p` | Paste (keep yank) | Paste karo aur yank register mat kho                   |

---

## 🔑 Which-key

| Key         | Action              | Kya karta hai                          |
| ----------- | ------------------- | -------------------------------------- |
| `<leader>?` | Show buffer keymaps | Current buffer ke saare keymaps dikhao |

---

## ⚡ Vim Default — Day to Day Fast Editing

> Ye sab Neovim ke built-in keys hain — koi plugin nahi chahiye

### 🔄 Modes

| Key     | Action               | Kya karta hai                        |
| ------- | -------------------- | ------------------------------------ |
| `i`     | Insert mode          | Cursor ke pehle type karo            |
| `a`     | Append               | Cursor ke baad type karo             |
| `I`     | Insert at line start | Line ke shuru mein type karo         |
| `A`     | Append at line end   | Line ke end mein type karo           |
| `o`     | New line below       | Neeche naya line banao aur type karo |
| `O`     | New line above       | Upar naya line banao aur type karo   |
| `v`     | Visual mode          | Character-wise select karo           |
| `V`     | Visual line mode     | Poori line select karo               |
| `<C-v>` | Visual block mode    | Block select karo (column-wise)      |
| `<Esc>` | Normal mode          | Wapas normal mode mein jao           |

---

### 🏃 Motion (Movement)

| Key             | Action                 | Kya karta hai                             |
| --------------- | ---------------------- | ----------------------------------------- |
| `h`             | Left                   | Ek character left                         |
| `l`             | Right                  | Ek character right                        |
| `j`             | Down                   | Ek line neeche                            |
| `k`             | Up                     | Ek line upar                              |
| `w`             | Next word start        | Agla word ka shuru                        |
| `b`             | Prev word start        | Pichla word ka shuru                      |
| `e`             | Next word end          | Agla word ka end                          |
| `W` / `B` / `E` | Same but WORD          | Space-separated WORD pe kaam karta hai    |
| `0`             | Line start (col 0)     | Line ke bilkul shuru mein jao             |
| `^`             | Line start (non-blank) | Line ke pehle character pe jao            |
| `$`             | Line end               | Line ke end mein jao                      |
| `gg`            | File start             | File ke shuru mein jao                    |
| `G`             | File end               | File ke end mein jao                      |
| `{`             | Prev paragraph         | Pichla blank line / paragraph             |
| `}`             | Next paragraph         | Agla blank line / paragraph               |
| `%`             | Matching bracket       | Matching `(`, `[`, `{` pe jao             |
| `f{char}`       | Find char (forward)    | Line mein aage wala character dhundho     |
| `F{char}`       | Find char (backward)   | Line mein peeche wala character dhundho   |
| `t{char}`       | Till char (forward)    | Character se ek pehle jao                 |
| `T{char}`       | Till char (backward)   | Character se ek baad jao (backward)       |
| `;`             | Repeat f/t             | f/t ko aage repeat karo                   |
| `,`             | Repeat f/t (reverse)   | f/t ko peeche repeat karo                 |
| `*`             | Search word forward    | Cursor ke neeche wala word aage dhundho   |
| `#`             | Search word backward   | Cursor ke neeche wala word peeche dhundho |
| `n`             | Next search result     | Agla search result                        |
| `N`             | Prev search result     | Pichla search result                      |
| `<C-o>`         | Jump back              | Pichli jagah pe wapas jao                 |
| `<C-i>`         | Jump forward           | Aage wali jagah pe jao                    |
| `''`            | Last cursor position   | Jahan cursor tha wahan wapas jao          |

---

### ✂️ Edit (Fast Typing)

| Key          | Action             | Kya karta hai                                      |
| ------------ | ------------------ | -------------------------------------------------- |
| `x`          | Delete char        | Cursor ke neeche wala character delete karo        |
| `X`          | Delete char before | Cursor ke pehle wala character delete karo         |
| `dd`         | Delete line        | Poori line delete karo (clipboard mein bhi)        |
| `D`          | Delete to end      | Cursor se line end tak delete karo                 |
| `cc`         | Change line        | Poori line delete karke insert mode mein jao       |
| `C`          | Change to end      | Cursor se end tak delete karke type karo           |
| `cw`         | Change word        | Word delete karke type karo                        |
| `ciw`        | Change inner word  | Poora word (cursor kahin bhi ho) change karo       |
| `ci"`        | Change inside `"`  | Quotes ke andar ka content change karo             |
| `ci(`        | Change inside `(`  | Parentheses ke andar change karo                   |
| `ci{`        | Change inside `{`  | Curly braces ke andar change karo                  |
| `ca"`        | Change around `"`  | Quotes samet change karo                           |
| `di"`        | Delete inside `"`  | Quotes ke andar delete karo                        |
| `yi"`        | Yank inside `"`    | Quotes ke andar copy karo                          |
| `yy`         | Yank line          | Poori line copy karo                               |
| `yw`         | Yank word          | Word copy karo                                     |
| `yiw`        | Yank inner word    | Poora word copy karo                               |
| `p`          | Paste after        | Cursor ke baad paste karo                          |
| `P`          | Paste before       | Cursor ke pehle paste karo                         |
| `u`          | Undo               | Pichla kaam undo karo                              |
| `<C-r>`      | Redo               | Undo hua kaam wapas lao                            |
| `.`          | Repeat last change | Jo abhi kiya wahi dobara karo — **bahut powerful** |
| `r{char}`    | Replace char       | Ek character replace karo                          |
| `R`          | Replace mode       | Type karo aur characters replace hote jayenge      |
| `~`          | Toggle case        | Character ka case upper/lower toggle karo          |
| `gu{motion}` | Lowercase          | Selection ko lowercase karo                        |
| `gU{motion}` | Uppercase          | Selection ko uppercase karo                        |
| `J`          | Join lines         | Neeche wali line ko current line se jodo           |
| `>>`         | Indent right       | Line ko right indent karo                          |
| `<<`         | Indent left        | Line ko left indent karo                           |
| `=`          | Auto indent        | Selection ko auto-indent karo                      |
| `==`         | Auto indent line   | Current line auto-indent karo                      |

---

### 🔢 Numbers & Counts

| Key     | Action            | Kya karta hai                                               |
| ------- | ----------------- | ----------------------------------------------------------- |
| `5j`    | Move 5 lines down | 5 lines neeche jao (koi bhi motion ke saath kaam karta hai) |
| `3dd`   | Delete 3 lines    | 3 lines delete karo                                         |
| `2yy`   | Yank 2 lines      | 2 lines copy karo                                           |
| `<C-a>` | Increment number  | Cursor ke neeche wala number badhao                         |
| `<C-x>` | Decrement number  | Cursor ke neeche wala number ghatao                         |

---

### 🔍 Search & Replace

| Key              | Action               | Kya karta hai                       |
| ---------------- | -------------------- | ----------------------------------- |
| `/pattern`       | Search forward       | Aage search karo                    |
| `?pattern`       | Search backward      | Peeche search karo                  |
| `:%s/old/new/g`  | Replace all          | Poori file mein replace karo        |
| `:%s/old/new/gc` | Replace with confirm | Har replace pe confirm karo         |
| `:s/old/new/g`   | Replace in line      | Sirf current line mein replace karo |

---

### 📁 File & Saving

| Key           | Action            | Kya karta hai                           |
| ------------- | ----------------- | --------------------------------------- |
| `:w`          | Save              | File save karo                          |
| `:wq` or `ZZ` | Save and quit     | Save karke band karo                    |
| `:q!` or `ZQ` | Quit without save | Bina save ke band karo                  |
| `:wa`         | Save all          | Saari files save karo                   |
| `:e filename` | Open file         | File kholo                              |
| `:e!`         | Reload file       | File dobara load karo (changes discard) |

---

### 📌 Marks & Jumps

| Key          | Action            | Kya karta hai                      |
| ------------ | ----------------- | ---------------------------------- |
| `m{a-z}`     | Set mark          | Is jagah pe mark lagao (e.g. `ma`) |
| `` `{a-z} `` | Jump to mark      | Mark pe wapas jao (exact position) |
| `'{a-z}`     | Jump to mark line | Mark wali line pe jao              |

---

### 🪟 Folds

| Key  | Action          | Kya karta hai           |
| ---- | --------------- | ----------------------- |
| `za` | Toggle fold     | Fold kholo ya band karo |
| `zc` | Close fold      | Fold band karo          |
| `zo` | Open fold       | Fold kholo              |
| `zR` | Open all folds  | Saare folds kholo       |
| `zM` | Close all folds | Saare folds band karo   |

---

### 💡 Pro Tips

| Key             | Action          | Kya karta hai                                          |
| --------------- | --------------- | ------------------------------------------------------ |
| `ci"` then `.`  | Change + repeat | Ek baar change karo, baaki jagah `.` se repeat karo    |
| `*` then `cgn`  | Search + change | Word dhundho, `cgn` se change karo, `.` se aage repeat |
| `V` + `>` + `.` | Indent multiple | Line select karo, indent karo, `.` se dobara           |
| `<C-v>` + `I`   | Block insert    | Multiple lines mein ek saath type karo                 |
| `q{a}` ... `q`  | Record macro    | Macro record karo `qa`, band karo `q`                  |
| `@{a}`          | Play macro      | Macro chalao                                           |
| `@@`            | Repeat macro    | Pichla macro dobara chalao                             |

---

## 📋 Registers (Clipboard System)

| Key    | Action                      | Kya karta hai                                               |
| ------ | --------------------------- | ----------------------------------------------------------- |
| `"ayy` | Yank to register a          | Line ko register `a` mein copy karo                         |
| `"ap`  | Paste from register a       | Register `a` se paste karo                                  |
| `"+y`  | Yank to system clipboard    | System clipboard mein copy karo                             |
| `"+p`  | Paste from system clipboard | System clipboard se paste karo                              |
| `"0p`  | Paste last yank             | Last yanked text paste karo (delete se overwrite nahi hota) |
| `"_dd` | Delete to black hole        | Delete karo lekin clipboard mein mat daalo                  |
| `:reg` | Show all registers          | Saare registers ka content dikhao                           |

---

## 🖥️ Insert Mode Shortcuts

| Key          | Action               | Kya karta hai                                         |
| ------------ | -------------------- | ----------------------------------------------------- |
| `<C-w>`      | Delete word back     | Insert mode mein pichla word delete karo              |
| `<C-u>`      | Delete to line start | Insert mode mein line shuru tak delete karo           |
| `<C-t>`      | Indent line          | Insert mode mein line indent karo                     |
| `<C-d>`      | Unindent line        | Insert mode mein line unindent karo                   |
| `<C-r>{reg}` | Paste register       | Insert mode mein register paste karo (e.g. `<C-r>a`)  |
| `<C-r>+`     | Paste clipboard      | Insert mode mein system clipboard paste karo          |
| `<C-o>{cmd}` | One normal cmd       | Insert mode se ek normal command chalao, wapas insert |
| `<C-a>`      | Repeat last insert   | Last insert mode mein jo type kiya wahi dobara        |

---

## 🔤 Command Mode (`:`) Tips

| Key               | Action                   | Kya karta hai                                 |
| ----------------- | ------------------------ | --------------------------------------------- |
| `<C-r><C-w>`      | Insert word under cursor | Command mein cursor ke neeche wala word daalo |
| `<Up>` / `<Down>` | History navigate         | Pichle commands browse karo                   |
| `<C-f>`           | Open command history     | Command history window kholo                  |
| `q:`              | Command history window   | Normal mode se command history kholo          |
| `q/`              | Search history window    | Search history kholo                          |
| `:!{cmd}`         | Run shell command        | Shell command chalao (e.g. `:!ls`)            |
| `:r !{cmd}`       | Insert cmd output        | Shell command ka output file mein daalo       |
| `:.!{cmd}`        | Filter line thru cmd     | Current line ko shell command se process karo |
| `:earlier 5m`     | Go back 5 minutes        | 5 minute pehle wali state mein jao            |
| `:later 5m`       | Go forward 5 minutes     | 5 minute baad wali state mein jao             |

---

## 🪟 Windows & Splits (Built-in)

| Key       | Action              | Kya karta hai                              |
| --------- | ------------------- | ------------------------------------------ |
| `<C-w>w`  | Cycle windows       | Agle window mein jao                       |
| `<C-w>p`  | Previous window     | Pichle window mein jao                     |
| `<C-w>o`  | Close other windows | Sirf current window rakho, baaki band karo |
| `<C-w>r`  | Rotate windows      | Windows ko rotate karo                     |
| `<C-w>x`  | Swap windows        | Current aur next window swap karo          |
| `<C-w>T`  | Move to new tab     | Current window ko naye tab mein le jao     |
| `<C-w>+`  | Increase height     | Window ki height badhao                    |
| `<C-w>-`  | Decrease height     | Window ki height ghatao                    |
| `<C-w>>`  | Increase width      | Window ki width badhao                     |
| `<C-w><`  | Decrease width      | Window ki width ghatao                     |
| `<C-w>=`  | Equalize all        | Saari windows equal size karo              |
| `<C-w>_`  | Max height          | Window ki height maximize karo             |
| `<C-w>\|` | Max width           | Window ki width maximize karo              |

---

## 📑 Tabs (Built-in)

| Key     | Action       | Kya karta hai                         |
| ------- | ------------ | ------------------------------------- |
| `gt`    | Next tab     | Agla tab                              |
| `gT`    | Previous tab | Pichla tab                            |
| `{n}gt` | Go to tab n  | n number wale tab pe jao (e.g. `2gt`) |
| `:tabn` | Next tab     | Agla tab                              |
| `:tabp` | Previous tab | Pichla tab                            |

---

## 🔁 Repeat & Dot Tricks

| Key  | Action                 | Kya karta hai                                |
| ---- | ---------------------- | -------------------------------------------- |
| `.`  | Repeat last change     | **Sabse powerful key** — jo kiya wahi dobara |
| `@:` | Repeat last command    | Last `:` command dobara chalao               |
| `&`  | Repeat last substitute | Last `:s` command dobara chalao              |
| `n.` | Next match + repeat    | Search result pe jao aur same change karo    |

---

## 🎯 Text Objects (ciw jaisi family)

> Format: `{operator}{a or i}{object}` — e.g. `daw`, `cit`, `vis`

| Object     | Meaning                | Example                             |
| ---------- | ---------------------- | ----------------------------------- |
| `w`        | word                   | `ciw` = word change                 |
| `W`        | WORD (space-separated) | `daW` = WORD delete with space      |
| `s`        | sentence               | `dis` = sentence delete             |
| `p`        | paragraph              | `dap` = paragraph delete            |
| `"`        | double quotes          | `ci"` = inside quotes change        |
| `'`        | single quotes          | `yi'` = inside single quotes copy   |
| `` ` ``    | backticks              | `di\`` = inside backticks delete    |
| `(` or `)` | parentheses            | `ca(` = parens samet change         |
| `[` or `]` | square brackets        | `yi[` = inside brackets copy        |
| `{` or `}` | curly braces           | `ci{` = inside braces change        |
| `<` or `>` | angle brackets         | `da<` = angle brackets samet delete |
| `t`        | HTML/XML tag           | `cit` = tag ke andar change         |
| `b`        | block `()`             | `dib` = block delete                |
| `B`        | block `{}`             | `diB` = curly block delete          |

---

## 🔠 Case & Transform

| Key    | Action             | Kya karta hai                  |
| ------ | ------------------ | ------------------------------ |
| `~`    | Toggle case (char) | Ek character ka case badlo     |
| `g~iw` | Toggle case (word) | Poore word ka case toggle karo |
| `guiw` | Lowercase word     | Word ko lowercase karo         |
| `gUiw` | Uppercase word     | Word ko uppercase karo         |
| `guu`  | Lowercase line     | Poori line lowercase           |
| `gUU`  | Uppercase line     | Poori line uppercase           |

---

## 📍 Jumps & Location List

| Key        | Action               | Kya karta hai                   |
| ---------- | -------------------- | ------------------------------- |
| `<C-o>`    | Jump back            | Pichli location pe jao          |
| `<C-i>`    | Jump forward         | Agle location pe jao            |
| `:jumps`   | Show jump list       | Saari jump locations dikhao     |
| `:changes` | Show change list     | Saari changes ki list dikhao    |
| `g;`       | Prev change location | Pichli change wali jagah pe jao |
| `g,`       | Next change location | Agli change wali jagah pe jao   |

---

## 🔡 Spell Check

| Key            | Action              | Kya karta hai                    |
| -------------- | ------------------- | -------------------------------- |
| `:set spell`   | Enable spell check  | Spell check on karo              |
| `:set nospell` | Disable spell check | Spell check off karo             |
| `]s`           | Next misspelled     | Agla galat word                  |
| `[s`           | Prev misspelled     | Pichla galat word                |
| `z=`           | Suggest corrections | Sahi spelling suggest karo       |
| `zg`           | Add to dictionary   | Word ko dictionary mein add karo |
| `zw`           | Mark as wrong       | Word ko galat mark karo          |

---

## 💻 Terminal (toggleterm.nvim + Built-in)

| Key            | Action              | Kya karta hai                          |
| -------------- | ------------------- | -------------------------------------- |
| `<C-\>`        | Toggle terminal     | Floating terminal kholo/band karo      |
| `:term`        | Open terminal       | Neovim ke andar terminal kholo         |
| `:vsp \| term` | Terminal in vsplit  | Vertical split mein terminal           |
| `i` or `a`     | Enter terminal mode | Terminal mein type karna shuru karo    |
| `<C-\><C-n>`   | Exit terminal mode  | Terminal se normal mode mein wapas jao |

---

## 🔃 Quickfix List

| Key              | Action         | Kya karta hai           |
| ---------------- | -------------- | ----------------------- |
| `:copen`         | Open quickfix  | Quickfix list kholo     |
| `:cclose`        | Close quickfix | Quickfix list band karo |
| `:cnext` / `:cn` | Next item      | Agla quickfix item      |
| `:cprev` / `:cp` | Prev item      | Pichla quickfix item    |
| `:cfirst`        | First item     | Pehla item              |
| `:clast`         | Last item      | Aakhri item             |

---

## 🧩 Misc But Useful

| Key          | Action                     | Kya karta hai                                      |
| ------------ | -------------------------- | -------------------------------------------------- |
| `K`          | Hover docs                 | Cursor ke neeche wale word ka documentation dikhao |
| `gf`         | Go to file                 | Cursor ke neeche wala filename kholo               |
| `ga`         | Show char info             | Character ka ASCII/Unicode value dikhao            |
| `g8`         | Show UTF-8 bytes           | Character ke UTF-8 bytes dikhao                    |
| `<C-g>`      | File info                  | Current file ka naam aur position dikhao           |
| `:sort`      | Sort lines                 | Selected lines sort karo                           |
| `:sort!`     | Sort reverse               | Reverse sort karo                                  |
| `:sort u`    | Sort unique                | Sort karke duplicates hatao                        |
| `zz`         | Center cursor              | Cursor wali line ko screen center mein lao         |
| `zt`         | Cursor to top              | Cursor wali line ko screen top pe lao              |
| `zb`         | Cursor to bottom           | Cursor wali line ko screen bottom pe lao           |
| `<C-e>`      | Scroll down (cursor stays) | Screen neeche scroll karo, cursor nahi hila        |
| `<C-y>`      | Scroll up (cursor stays)   | Screen upar scroll karo, cursor nahi hila          |
| `gv`         | Reselect last visual       | Last visual selection dobara select karo           |
| `o` (visual) | Other end of selection     | Selection ke doosre end pe jao                     |
