#####################
### CONFIGURATION ###
#####################

PREFIX ?= ~

BINDIR ?= bin

BACKDIR ?= backup

SOURCES = \
		  .vim \
		  .vimrc \
		  .gvimrc \
		  .bashrc \
		  .zshrc \
		  .tmux.conf \
		  .gitconfig \
		  .Xresources \
		  .Xresources_local \

YCM_FLAGS = \
			--clang-completer

TARGETS = $(addprefix $(PREFIX)/, $(SOURCES))

BACKUPS = $(addprefix $(BACKDIR)/, $(SOURCES))


#####################
### GENERAL RULES ###
#####################

.PHONY: all
all: install

.PHONY: install
install: $(TARGETS) install_xresources install_vim install_submodules
	git submodule update --init --recursive

.PHONY: uninstall
uninstall:
	rm -rf $(TARGETS)

.PHONY: backup
backup:
	mkdir -p $(BACKDIR)
	cp -r $(TARGETS) $(BACKDIR) | true

.PHONY: restore
restore:
	cp -rf $(BACKUPS) $(PREFIX)

$(PREFIX)/%: %
	ln -s $(abspath $<) $@


######################
### SPECIFIC RULES ###
######################

.PHONY: install_submodules
install_submodules: | .vim/bundle/Vundle.vim/README.md
	git submodule update --init --recursive

$(PREFIX)/.Xresources_local: .Xresources_local
	test -e $@ || cp $< $@

.PHONY: install_xresources
install_xresources: $(PREFIX)/.Xresources $(PREFIX)/.Xresources_local
	xrdb -merge $< || true

.PHONY: install_vim
install_vim: | $(PREFIX)/.vimrc $(PREFIX)/.vim install_vim_modules install_vim_module_ycm

.PHONY: install_vim_modules
install_vim_modules:
	vim +PluginInstall +qall

.PHONY: install_vim_module_ycm
install_vim_module_ycm: | $(PREFIX)/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so install_vim_modules

$(PREFIX)/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so: | install_vim_modules install_submodules
	cd $(PREFIX)/.vim/bundle/YouCompleteMe ; ./install.py $(YCM_FLAGS)

