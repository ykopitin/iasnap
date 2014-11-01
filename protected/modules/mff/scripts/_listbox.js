function listbox_multi_keypress(e, obj) {
    alert(e.key);
    if (e.key=="Del") {
        obj.selectedIndex=-1;
        return;
    }
    
}