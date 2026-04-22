if status is-interactive
    # Commands to run in interactive sessions can go here
end

# 1. FORCE PYTHON 3.13 TO BE FOUND FIRST (Highest Priority)
# This MUST come before the general Homebrew bin path to override the default python3 symlink.
set -x PATH "/opt/homebrew/opt/python@3.12/bin" $PATH

# 2. GENERAL HOMEBREW BINARY PATH
set -x PATH "/opt/homebrew/bin" $PATH

# 3. NODE VERSION MANAGER (FNM)
# This uses the fnm function to correctly set the Node PATH dynamically.
fnm env --use-on-cd | source

# 4. LOCAL AND CUSTOM BINARY PATHS
set -x PATH "$HOME/.local/bin" $PATH
set -x PATH "/opt/nvim/bin" $PATH # If nvim is installed outside Homebrew

# 5. GO LANGUAGE PATHS
set -x GOROOT "/usr/local/go"
set -x GOPATH "$HOME/go"
# Add Go bins to PATH (note: $GOROOT/bin and $GOPATH/bin should be added after the system paths)
set -x PATH "$GOROOT/bin" "$GOPATH/bin" $PATH
set -x PATH "/usr/local/go/bin/" $PATH

# 6. SHELL VARIABLES (ZSH/Editor)
set -x ZSH "$HOME/.oh-my-zsh/"
set -x EDITOR "nvim"
set -x VISUAL "nvim"
abbr vi "nvim"

#7. vulkan installation
set -gx LIBRARY_PATH /opt/homebrew/lib $LIBRARY_PATH
set -gx CPATH /opt/homebrew/include $CPATH
set -gx VULKAN_SDK $HOME/VulkanSDK/1.4.335.1/macOS
set -gx DYLD_LIBRARY_PATH $VULKAN_SDK/lib $DYLD_LIBRARY_PATH
set -gx VK_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d


# --- Git Abbreviations ---
abbr --add gst "git status"
abbr --add ga "git add"
abbr --add gap "git add -p"
abbr --add gan "git add -N"
abbr --add gc "git commit"
abbr --add gcm "git commit -m"
abbr --add gdf "git diff"
abbr --add gpo "git push origin"
abbr --add gco "git checkout"
abbr --add dev "git checkout dev"
abbr --add stag "git checkout stag"
abbr --add gm "git merge"
abbr --add gl "git log"
abbr --add glo "git log --oneline"
abbr --add gf "git fetch"
abbr --add gfu "git fetch upstream"
# ------------------------- 


# --- Surge Abbreviations ---
abbr --add sg "surge generate"
abbr --add sr "surge run"
# ------------------------- 


# Added by Antigravity
fish_add_path /Users/kalpesh/.antigravity/antigravity/bin

# Added by Antigravity
fish_add_path /Users/kalpesh/.antigravity/antigravity/bin

# Added by Antigravity
fish_add_path /Users/kalpesh/.antigravity/antigravity/bin

# Added by Antigravity
fish_add_path /Users/kalpesh/.antigravity/antigravity/bin
