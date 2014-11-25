/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function ff_scanFile (appletId, filepath, filecontext, filecrypt) {        
    var busytimeount = 600000;
    var intervalId=setInterval(
            function(){
                var jScan=document.getElementById(appletId);
                if (!jScan.isBusy()) {
                    clearInterval(intervalId);
//                    var data=jScan.getData();
                    var data=jScan.getPDF();
                    if (data) {
                        ff_loadFile(filepath, filecontext, filecrypt, '',data);   
                    } 
                    return;
                }
                busytimeount=busytimeount-500;
                if (busytimeount<=0) {
                    clearInterval(intervalId);
                }
            }
            ,500);
}
