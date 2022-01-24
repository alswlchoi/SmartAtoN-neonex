var $ = jQuery.noConflict();


var oneNum, twoNum, thrNum, fouNum;
var curOne, curTwo, curThr, curFou;


	
jQuery(document).ready(function(){
	var pathname = "";
	var lastname = "";

	var split = location.pathname.split("/");
	lastname = "/"+split.pop().split(".")[0];
	
	for(var i=0; i<split.length; i++) {
		pathname += split[i] + "/";
	}
	
	// 서브 이미지 셋팅
	setSubImg(oneNum);	
	
	curOne = oneNum;
	curTwo = twoNum;
	curThr = thrNum;
	curFou = fouNum;
	

	jQuery(".navi1Ul").children("li").eq(oneNum).addClass("on");
	jQuery(".navi1Ul").children("li").each(function(q){
		jQuery(this).hover(function(){
			jQuery(".navi1Ul").children("li").eq(oneNum).removeClass("on");
			jQuery(".navi1").stop().animate({height:219}, 300, "easeOutCubic");
			//jQuery(".gnbShadow").stop().animate({top:438}, 300, "easeOutCubic");
			jQuery(this).addClass("on");
		}, function(){
			jQuery(".navi1").stop().animate({height:65}, 300, "easeOutCubic");
			jQuery(this).removeClass("on");
			jQuery(".navi1Ul").children("li").eq(oneNum).addClass("on");
			jQuery(".gnbShadow").stop().animate({top:140}, 300, "easeOutCubic");
		}).focusin(function(){
			jQuery(".navi1Ul").children("li").eq(oneNum).removeClass("on");
			jQuery(".navi1").stop().animate({height:219}, 300, "easeOutCubic");
			//jQuery(".gnbShadow").stop().animate({top:438}, 300, "easeOutCubic");
			jQuery(this).addClass("on");
		}).focusout(function(){
			jQuery(".navi1").stop().animate({height:65}, 300, "easeOutCubic");
			jQuery(this).removeClass("on");
			jQuery(".navi1Ul").children("li").eq(oneNum).addClass("on");
			//jQuery(".gnbShadow").stop().animate({top:140}, 300, "easeOutCubic");
		})
	})
	
	jQuery(".navi2Ul").children("li").eq(oneNum).addClass("on");
	jQuery(".navi2Ul").children("li").each(function(q){
		jQuery(this).hover(function(){
			jQuery(".navi2Ul").children("li").eq(oneNum).removeClass("on");
			jQuery("#gnb_main").stop().animate({height:290}, 300, "easeOutCubic");
			//jQuery(".gnbShadow").stop().animate({top:438}, 300, "easeOutCubic");
			jQuery(this).addClass("on");
		}, function(){
			jQuery("#gnb_main").stop().animate({height:63}, 300, "easeOutCubic");
			jQuery(this).removeClass("on");
			jQuery(".navi2Ul").children("li").eq(oneNum).addClass("on");
			jQuery(".gnbShadow").stop().animate({top:140}, 300, "easeOutCubic");
		}).focusin(function(){
			jQuery(".navi2Ul").children("li").eq(oneNum).removeClass("on");
			jQuery("#gnb_main").stop().animate({height:290}, 300, "easeOutCubic");
			//jQuery(".gnbShadow").stop().animate({top:438}, 300, "easeOutCubic");
			jQuery(this).addClass("on");
		}).focusout(function(){
			jQuery("#gnb_main").stop().animate({height:63}, 300, "easeOutCubic");
			jQuery(this).removeClass("on");
			jQuery(".navi2Ul").children("li").eq(oneNum).addClass("on");
			//jQuery(".gnbShadow").stop().animate({top:140}, 300, "easeOutCubic");
		})
	})

})

// 서브 이미지 셋팅
function setSubImg(gnbSeq){ 
	var seq = gnbSeq + 1;
	var className ='';
	
	if(seq == 1){ // 1번째
		  className = "visual";
	}else if(seq  > 1 && seq < 7){	// 나머지 서브 이미지 부분
		 className= "visual"+seq;
	}
	/*/
	if(seq == 7){ // util 
		 className= "visual5";
	}
	/**/
	//trace(className);
	$("#cBody p#subVisualP").addClass( className ); 
}

// t: current time, b: begInnIng value, c: change In value, d: duration
jQuery.easing['jswing'] = jQuery.easing['swing'];

jQuery.extend( jQuery.easing,
{
	def: 'easeOutQuad',
	swing: function (x, t, b, c, d) {
		//alert(jQuery.easing.default);
		return jQuery.easing[jQuery.easing.def](x, t, b, c, d);
	},
	easeInQuad: function (x, t, b, c, d) {
		return c*(t/=d)*t + b;
	},
	easeOutQuad: function (x, t, b, c, d) {
		return -c *(t/=d)*(t-2) + b;
	},
	easeInOutQuad: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	},
	easeInCubic: function (x, t, b, c, d) {
		return c*(t/=d)*t*t + b;
	},
	easeOutCubic: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t + 1) + b;
	},
	easeInOutCubic: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	},
	easeInQuart: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t + b;
	},
	easeOutQuart: function (x, t, b, c, d) {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	},
	easeInOutQuart: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	},
	easeInQuint: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t*t + b;
	},
	easeOutQuint: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	},
	easeInOutQuint: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	},
	easeInSine: function (x, t, b, c, d) {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	},
	easeOutSine: function (x, t, b, c, d) {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	},
	easeInOutSine: function (x, t, b, c, d) {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	},
	easeInExpo: function (x, t, b, c, d) {
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
	},
	easeOutExpo: function (x, t, b, c, d) {
		return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
	},
	easeInOutExpo: function (x, t, b, c, d) {
		if (t==0) return b;
		if (t==d) return b+c;
		if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
		return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
	},
	easeInCirc: function (x, t, b, c, d) {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	},
	easeOutCirc: function (x, t, b, c, d) {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	},
	easeInOutCirc: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	},
	easeInElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	},
	easeOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
	},
	easeInOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	},
	easeInBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	},
	easeOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	},
	easeInOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158; 
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	},
	easeInBounce: function (x, t, b, c, d) {
		return c - jQuery.easing.easeOutBounce (x, d-t, 0, c, d) + b;
	},
	easeOutBounce: function (x, t, b, c, d) {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	},
	easeInOutBounce: function (x, t, b, c, d) {
		if (t < d/2) return jQuery.easing.easeInBounce (x, t*2, 0, c, d) * .5 + b;
		return jQuery.easing.easeOutBounce (x, t*2-d, 0, c, d) * .5 + c*.5 + b;
	}
});