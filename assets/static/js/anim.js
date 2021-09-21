"use strict";

function animate_spinner(class_to_add) {
    var spinner = document.getElementById("spinner");
    spinner.style.animation = 'none';
    spinner.offsetHeight;
    spinner.style.animation = null; 
    spinner.className = class_to_add;
}