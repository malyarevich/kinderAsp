
//Loads the correct sidebar on window load,
//collapses the sidebar on window resize.
// Sets the min-height of #page-wrapper to window size
jQuery(function() {
    jQuery(window).bind("load resize", function() {
        topOffset = 50;
        width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            jQuery('div.navbar-collapse').addClass('collapse')
            topOffset = 100; // 2-row-menu
        } else {
            jQuery('div.navbar-collapse').removeClass('collapse')
        }

        height = (this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            jQuery("#page-wrapper").css("min-height", (height) + "px");
        }
    })
});

String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

var customFunc = function customFunction() {
    switchVs();
    jQuery(document).on('click','#profileToggle', function(){
        jQuery(this).find('.btn').toggleClass('active');

        if (jQuery(this).find('.btn-primary').size()>0) {
            switchVs("parentInfo", "personalInfo");
            jQuery(this).find('.btn').toggleClass('btn-primary');
        }
        jQuery(this).find('.btn').toggleClass('btn-default');
    });
}

function ready() {
    
    customFunc();
}

document.addEventListener("DOMContentLoaded", ready);

jQuery("#side-menu>li>a").click(function(evt) {
    jQuery("#side-menu>li>a").removeClass("active");
    jQuery(this).addClass("active");
    console.log(this.hash);
});

//----------------------------------------------------------------------------------------------------------------


chw = function chooseHeightWeight() {
    jQuery('#span_height').click(function() {
        jQuery('#span_height').hide();
        jQuery('#height_input').show();
        sethw();
    });
    jQuery('#span_weight').click(function() {
        jQuery('#span_weight').hide();
        jQuery('#weight_input').show();
        sethw();
    });
}

sethw = function setHeightWeight() {
    jQuery(document).ready(function() {
        jQuery('#height_input').keydown(function(e) {
            if (e.keyCode === 13) {
                jQuery('#height_input').hide();
                jQuery('#span_height').show();
            }
        });
    });

    jQuery(document).ready(function() {
        jQuery('#weight_input').keydown(function(e) {
            if (e.keyCode === 13) {
                jQuery('#weight_input').hide();
                jQuery('#span_weight').show();
            }
        });
    });
}

sdii = function setDataInInputs() {
    jQuery('#table_med tr').click(function() {
        jQuery('#cancel_vac').show();
        jQuery(this).find('td').each(function() {
            var value = jQuery(this).html();
            var type = jQuery(this).attr('type');

            jQuery('.inputs #' + type).val(value);
            jQuery("#select_type_vaccination :contains(" + value + ")").prop("selected", true);
            jQuery("#select_reason_vaccination :contains(" + value + ")").prop("selected", true);
        });
    });
}

gd = function getDataFromImputs() {
    jQuery("#submit_vaccination_info").click(function() {
        var type = jQuery("#select_type_vaccination :selected").val(); //val
        var reason = jQuery("#select_reason_vaccination :selected").text();
        var date = jQuery("#date_vac").val();
        var term = jQuery("#term_vac").val();
        jQuery('#cancel_vac').hide();
        clear();
        return false;
    });
    jQuery("#cancel_vac").click(function() {
        jQuery('#cancel_vac').hide();
        clear();
    });
}

clear = function clearVacInputs() {
    jQuery("#select_type_vaccination :first").prop("selected", true);
    jQuery("#select_reason_vaccination :first").prop("selected", true);
    jQuery("#date_vac").val('');
    jQuery("#term_vac").val('');
}


// -----------------------------------Lesha---------------------------------------

 switchVs=function switchVisible(firstBlock, secondBlock) {
     dcRdy();
    if (document.getElementById(firstBlock)) {
        if (document.getElementById(firstBlock).style.display == 'none') {
            document.getElementById(firstBlock).style.display = 'block';
            document.getElementById(secondBlock).style.display = 'none';
        }
        else {
            document.getElementById(firstBlock).style.display = 'none';
            document.getElementById(secondBlock).style.display = 'block';
        }
    }
}

dcRdy = function dcReady() {
    pageSize = 1;
    pagesCount = jQuery(".content").length;
    var currentPage = 1;

    /////////// PREPARE NAV ///////////////
    var nav = '';
    var totalPages = Math.ceil(pagesCount / pageSize);
    for (var s=0; s<totalPages; s++){
        nav += '<li class="numeros"><a href="#">'+(s+1)+'</a></li>';
    }
    jQuery(".pag_prev").after(nav);
    jQuery(".numeros").first().addClass("active");
    //////////////////////////////////////

    showPage = function() {
        jQuery(".content").hide().each(function(n) {
            if (n >= pageSize * (currentPage - 1) && n < pageSize * currentPage)
                jQuery(this).show();
        });
    }
    showPage();

    jQuery(".pagination li.numeros").click(function() {
        jQuery(".pagination li").removeClass("active");
        jQuery(this).addClass("active");
        currentPage = parseInt($(this).text());
        showPage();
    });

    jQuery(".pagination li.pag_prev").click(function() {
        if(jQuery(this).next().is('.active')) return;
        jQuery('.numeros.active').removeClass('active').prev().addClass('active');
        currentPage = currentPage > 1 ? (currentPage-1) : 1;
        showPage();
    });

    jQuery(".pagination li.pag_next").click(function() {
        if(jQuery(this).prev().is('.active')) return;
        jQuery('.numeros.active').removeClass('active').next().addClass('active');
        currentPage = currentPage < totalPages ? (currentPage+1) : totalPages;
        showPage();
    });
}
