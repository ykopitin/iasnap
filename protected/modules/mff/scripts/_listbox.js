function listbox_multi_keypress(e, obj) {
    if (e.key=="Del") {
        obj.selectedIndex=-1;
        return;
    }
    
}