window.onload = function(){

    var titleNav = document.getElementsByClassName("titleNav");
    var titleChild = document.getElementsByClassName("titleChild");
    var navEach = document.getElementsByClassName("nav_each");

    //�����򿪣��ٵ����ر�
    for(var i= 0;i<titleNav.length;i++){
        titleNav[i].onclick = function(e){
            e.stopPropagation();
            //console.info(this.parentNode.children[1]);
            if(this.parentNode.children[1].className == "titleChild"){
                this.parentNode.children[1].className = "showText";
            }else{
                this.parentNode.children[1].className = "titleChild";
            }

        }
    }
};
