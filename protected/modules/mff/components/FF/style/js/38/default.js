/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function() {
$("#formff_fieldvalue_legal_personality").on('change',"input:radio[name='FFModel[legal_personality]']", function(event){
    switch (event.currentTarget.value) {
        case '5': {
            $("#formff_field_organization").hide();
            break;
        }
        case '6': {
            $("#formff_field_organization").hide();
            break;
        }
        case '7': {
            $("#formff_field_organization").show();
            break;
        }
    }
});
    }
);

