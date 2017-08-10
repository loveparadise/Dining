$j(function() {
	
	if(!$j("#promotion")[0])
		return false;
	var totalPanels			= $j(".scrollContainer").children().size();
	
	var regWidth			= $j(".panel").css("width");
	var regImgWidth			= $j(".panel img").css("width");
	var regTitleSize		= $j(".panel h2").css("font-size");
	var regParSize			= $j(".panel p").css("font-size");
	
	var movingDistance	    = 300;
	
	var curWidth			= 350;
	var curImgWidth			= 326;
	var curTitleSize		= "20px";
	var curParSize			= "15px";

	var $jpanels				= $j('#slider .scrollContainer > div');
	var $jcontainer			= $j('#slider .scrollContainer');

	$jpanels.css({'float' : 'left','position' : 'relative'});
    
	$j("#slider").data("currentlyMoving", false);
	
	$jcontainer
		.css('width', ($jpanels[0].offsetWidth * $jpanels.length) + 100 ).css('left', "-350px");;
	if($jpanels.length==1)
	{
		$jcontainer.css('left', "300px");
	}
	if($jpanels.length==2)
	{
		$jcontainer.css('left', "200px");
	}
	if($jpanels.length==3)
	{
		$jcontainer.css('left', "60px");
	}
	if($jpanels.length==4)
	{
		$jcontainer.css('left', "-150px");
	}
	if($jpanels.length==5)
	{
		$jcontainer.css('left', "-350px");
	}
		

	var scroll = $j('#slider .scroll').css('overflow', 'hidden');

	function returnToNormal(element) {
		$j(element)
			.animate({ width: regWidth })
			.find("img")
			.animate({ width: regImgWidth })
		    .end()
			.find("h2")
			.animate({ fontSize: regTitleSize })
			.end()
			.find("p")
			.animate({ fontSize: regParSize });
	};
	
	function growBigger(element) {
		$j(element)
			.animate({ width: curWidth })
			.find("img")
			.animate({ width: curImgWidth })
		    .end()
			.find("h2")
			.animate({ fontSize: curTitleSize })
			.end()
			.find("p")
			.animate({ fontSize: curParSize });
	}
	
	//direction true = right, false = left
	function change(direction) {
	   
	    //if not at the first or last panel
		if((direction && !(curPanel < totalPanels)) || (!direction && (curPanel <= 1))) { return false; }	
        
        //if not currently moving
        if (($j("#slider").data("currentlyMoving") == false)) {
            
			$j("#slider").data("currentlyMoving", true);
			
			var next         = direction ? curPanel + 1 : curPanel - 1;
			var leftValue    = $j(".scrollContainer").css("left");
			var movement	 = direction ? parseFloat(leftValue, 10) - movingDistance : parseFloat(leftValue, 10) + movingDistance;
		
			$j(".scrollContainer")
				.stop()
				.animate({
					"left": movement
				}, function() {
					$j("#slider").data("currentlyMoving", false);
				});
			
			returnToNormal("#panel_"+curPanel);
			growBigger("#panel_"+next);
			
			curPanel = next;
			
			//remove all previous bound functions
			$j("#panel_"+(curPanel+1)).unbind();	
			
			//go forward
			$j("#panel_"+(curPanel+1)).click(function(){ change(true); });
			
            //remove all previous bound functions															
			$j("#panel_"+(curPanel-1)).unbind();
			
			//go back
			$j("#panel_"+(curPanel-1)).click(function(){ change(false); }); 
			
			//remove all previous bound functions
			$j("#panel_"+curPanel).unbind();
		}
	}
	
	// Set up "Current" panel and next and prev
	growBigger("#panel_3");	
	var curPanel = 3;
	
	$j("#panel_"+(curPanel+1)).click(function(){ change(true); });
	$j("#panel_"+(curPanel-1)).click(function(){ change(false); });
	
	//when the left/right arrows are clicked
	$j(".right").click(function(){ change(true); });	
	$j(".left").click(function(){ change(false); });
	
	$j(window).keydown(function(event){
	  switch (event.keyCode) {
			case 13: //enter
				$j(".right").click();
				break;
			case 32: //space
				$j(".right").click();
				break;
	    case 37: //left arrow
				$j(".left").click();
				break;
			case 39: //right arrow
				$j(".right").click();
				break;
	  }
	});
	
});