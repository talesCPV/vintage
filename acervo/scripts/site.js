/*
jQuery.Turbolinks ~ https://github.com/kossnocorp/jquery.turbolinks
jQuery plugin for drop-in fix binded events problem caused by Turbolinks

The MIT License
Copyright (c) 2012-2013 Sasha Koss & Rico Sta. Cruz
 */



function resizeModal(t) {
    var e = new Image;
    e.onload = function() {}, e.src = t
}

function currentImageSrc() {
    var t = $(".vehicle-image");
    return t.data("original") || t.attr("src")
}

function overlay() {
    return $("#lead-image-overlay .modal")
}

function setModalImage() {
    overlay().find(".modal-lead-image").html("<img src=" + currentImageSrc() + "></img>"), resizeModal(currentImageSrc())
}

function loadHammerJsOnLoad() {
    window.__loadedHammer = !0;
    var t = document.querySelector(".modal-lead-image");
    new Hammer(t).on("swipe tap", function(t) {
        console.log(t.type + " " + t.direction + " detected"), "tap" === t.type || "swipe" === t.type && t.direction === Hammer.DIRECTION_LEFT ? loadNextImage(t) : loadPrevImage(t), updateModal()
    })
}

function loadHammerJs() {
    if (window.__loadedHammer) loadHammerJsOnLoad();
    else {
        var t = document.createElement("script");
        t.src = "/assets/hammer.min-c8ef32df9e08e8d135a1e12284094ef2.js", t.type = "text/javascript", t.async = !0, t.onload = loadHammerJsOnLoad, document.body.appendChild(t)
    }
}



function extendGallery(t) {
    var e = t.find("a").length;
    t.animate({
        height: "+=" + 75 * Math.floor(e / 6)
    }, 1e3), t.addClass("extend"), event.target.innerHTML = "^"
}

function shrinkGallery(t) {
    t.animate({
        height: "75px"
    }, 1500), t.removeClass("extend"), event.target.innerHTML = "v"
}

function getImageSelector() {
    return $(".vehicle-image img:first").length > 0 ? $(".vehicle-image img:first") : $(".part-image img:first")
}

function currentImageSrc() {
    var t = getImageSelector();
    return t.data("original") || t.attr("src")
}







function navHideShow() {
    worldwidePageContent.currentScrollPos = window.pageYOffset, window.scrollY > 70 && allowScroll && (worldwidePageContent.prevScrollpos >= worldwidePageContent.currentScrollPos ? ($("header").removeClass("compress-nav"), $("#worldwide-menu-toggle").removeClass("compressed")) : ($("header").addClass("compress-nav"), $("#worldwide-menu-toggle").addClass("compressed")), window.scrollY > 300 && allowScroll ? worldwidePageContent.prevScrollpos >= worldwidePageContent.currentScrollPos ? $(".home-filters").addClass("nav-open") : ($(".home-filters").removeClass("nav-open"), $(".home-filters").addClass("sticky-home-filters")) : $(".home-filters").removeClass("sticky-home-filters")), worldwidePageContent.prevScrollpos = worldwidePageContent.currentScrollPos
}


function fullWidth() {
    $(".zoom-lead-icon").on("click", function() {
        var t = document.querySelectorAll(".show-car-thumbs a:not(.is-a-video)"),
            e = [];
        t.forEach(function(t) {
            e.push({
                src: t.attributes["data-original"].nodeValue,
                thumb: t.attributes.thumb.nodeValue,
                subHtml: t.attributes.alt.nodeValue
            })
        }), $(this).lightGallery({
            dynamic: !0,
            dynamicEl: e
        })
    }), $(".cast-img-responsive").on("click", function() {
        var t = document.querySelectorAll(".show-car-thumbs a:not(.is-a-video)"),
            e = [];
        t.forEach(function(t) {
            e.push({
                src: t.attributes["data-original"].nodeValue,
                thumb: t.attributes.thumb.nodeValue,
                subHtml: t.attributes.alt.nodeValue
            })
        }), $(this).lightGallery({
            dynamic: !0,
            dynamicEl: e
        })
    })
}



/* */


var lastScrollTop = 0,
    delta = 100,
    navbarHeight = $(".text-message-sticky-widget").outerHeight();


var allowScroll = !0,
    worldwidePageContent = {};

worldwidePageContent.prevScrollpos = window.pageYOffset, worldwidePageContentcurrentScrollPos = window.pageYOffset, worldwidePageContent.prevScrollposFilter = window.pageYOffset, $(document).on("click", "#worldwide-menu-toggle", function() {
    $(this).toggleClass("open"), $(".mobile-nav-slide-out").toggleClass("open-nav")
}), $(document).ready(function() {
    document.body.setAttribute("data-no-turbolink", !0), $(window).scroll(function() {
        navHideShow()
    })
}), $(document).on("click", ".mobile-menu-btn", function(t) {
    t.preventDefault(), $("body").toggleClass("fixed-body"), $(this).toggleClass("is-open"), $(".navigation-bottom-row").slideToggle(), setTimeout(function() {
        $(".navigation-bottom-row").toggleClass("fade-in")
    }, 100)
}), $(document).ready(function() {
    $(".inv-cta-btn").on("click", function() {
        $(".home-filters").addClass("sticky-home-filters"), $("html, body").animate({
            scrollTop: 200
        }, 500)
    })
}), $(document).ready(function() {
    $(".home-filter-toggle").on("click", function() {
        $(".home-filter-toggle").hasClass("open-filter-toggle") ? $(".home-filter-toggle").text("Show Filters").removeClass("open-filter-toggle") : $(".home-filter-toggle").text("Hide Filters").addClass("open-filter-toggle"), $(".worldwide-filters-wrap").toggleClass("open-filters")
    })
}), $(document).ready(function() {
    $(document).scroll(function() {
        if ($(document).width() > 991) {
            var t = $(document).scrollTop(),
                e = $(document).height() - $(document).scrollTop();
            t > 122 && $(".right-show").addClass("shift-up1"), t < 122 && $(".right-show").removeClass("shift-up1"), t > 180 && $(".right-show").addClass("shift-up2"), t < 180 && $(".right-show").removeClass("shift-up2"), e > 800 && $(".right-show").removeClass("shift-up3"), e < 800 && $(".right-show").addClass("shift-up3"), e > 1750 && $(".right-show").removeClass("shift-hide"), e < 1750 && $(".right-show").addClass("shift-hide"), e > 1550 && $(".right-show").removeClass("shift-hide2"), e < 1550 && $(".right-show").addClass("shift-hide2")
        }
    })

    
}), $(document).on("click", ".next", function() {
    var t = parseInt($(".current-photo").text());
    $(".current-photo").text(t + 1)
}), $(document).on("click", ".prev", function() {
    var t = parseInt($(".current-photo").text());
    $(".current-photo").text(t - 1)
}), $(document).on("click", ".custom-box", function() {
    $(this).hasClass("open") ? $(this).toggleClass("open") : ($(".custom-box.open").toggleClass("open"), $(this).toggleClass("open"))
}), $(document).on("ready", function() {
    $(".read-more-specs").on("click", function() {
        $(".spec-summary-container").toggleClass("open-specs"), $(".spec-summary-container").hasClass("open-specs") ? $(".read-more-specs span").text("View Less") : $(".read-more-specs span").text("View More")
    })
}), $(document).on("ready", function() {
    $(".read-more").on("click", function() {
        $(".shortened-desc").toggleClass("desc-hide"), $(".full-desc").toggleClass("desc-hide"), $(".full-desc").hasClass("desc-hide") ? $(".read-more span").text("Read More") : $(".read-more span").text("Read Less")
    })
}), $(document).on("click", "#worldwide-video-thumb", function(t) {
    t.preventDefault(), t.stopPropagation(), toggleVideo("on"), document.querySelector(".vehicle-top-image").scrollIntoView({
        behavior: "smooth",
        block: "start"
    })
}), $(document).on("click", ".show-car-thumbs a", function(t) {
    t.preventDefault(), toggleVideo("off")
}), $(document).ready(function() {
    $("#mute-video").click(function() {
        $("video").prop("muted") ? ($(this).toggleClass("video-mute"), $("video").prop("muted", !1)) : ($(this).toggleClass("video-mute"), $("video").prop("muted", !0))
    }), $("video").on("ended", function() {
        $(this).prop("loop", "loop"), $(this).prop("muted", "muted"), $(this)[0].play(), $("#mute-video").toggleClass("video-mute")
    })
}), $(document).ready(function() {
    fullWidth()

}), $(document).ready(function() {
    $("a.section-toggler").on("click", function(t) {
        t.preventDefault(), $(this).toggleClass("open-faq"), $(this).closest(".qq").find(".answer").slideToggle()
    })
}), $(document).ready(function() {
    "ssform" === sessionStorage.getItem("ssform") && ($(".contact-success.l-flash-success.ww").toggle(), $("#worldwide-consignment-form").toggle(), $("html, body").animate({
        scrollTop: $(".contact-success.l-flash-success.ww").offset().top - 200
    }, 300), sessionStorage.setItem("ssform", "refresh")), $("#worldwide-consignment-form").submit(function() {
        sessionStorage.setItem("ssform", "ssform")
    })
}), $(document).ready(function() {
    $("#worldwide_consignment_make_id").on("change", function() {
        var t = $("#worldwide_consignment_make_id option:selected").text();
        $("#sharpspring_vehicle_make").attr("value", t), $("#sharpspring_vehicle_make").text(t)
    }), $("#worldwide_consignment_model_id").on("change", function() {
        var t = $("#worldwide_consignment_model_id option:selected").text();
        $("#sharpspring_vehicle_model").attr("value", t), $("#sharpspring_vehicle_model").text(t)
    })
});