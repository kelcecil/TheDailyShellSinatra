function todays_date() {

    var date_string = "";
    var date = new Date();
    
    switch (date.getDay()) {
    case (0):
	date_string = "Sunday, ";
	break;
    case(1):
	date_string = "Monday, ";
	break;
    case(2):
	date_string = "Tuesday, ";
	break;
    case(3):
	date_string = "Wednesday, ";
	break;
    case(4):
	date_string = "Thursday, ";
	break;
    case(5):
	date_string = "Friday, ";
	break;
    case(6):
	date_string = "Saturday, ";
	break;
    }

    date_string = date_string + date.getDate() + " ";

    switch(date.getMonth()){
    case(0):
	date_string = date_string + "January "
	break;
    case(1):
	date_string = date_string + "February "
	break;
    case(2):
	date_string = date_string + "March "
	break;
    case(3):
	date_string = date_string + "April "
	break;
    case(4):
	date_string = date_string + "May "
	break;
    case(5):
	date_string = date_string + "June "
	break;
    case(6):
	date_string = date_string + "July "
	break;
    case(7):
	date_string = date_string + "August "
	break;
    case(8):
	date_string = date_string + "September "
	break;
    case(9):
	date_string = date_string + "October "
	break;
    case(10):
	date_string = date_string + "November "
	break;
    case(11):
	date_string = date_string + "December "
	break;
    }

    date_string = date_string + date.getFullYear();
    return date_string;
}

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-28726185-1']);
_gaq.push(['_trackPageview']);

(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();