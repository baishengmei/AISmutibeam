/**
 * Created by baishengmei on 2016/5/13.
 */
$(function(){

    //delete function
    var $modul_contain = $("#modul_contain");
    var $delete = $("#delete");
    $delete.bind("click", function () {
        $(".modul_contain tbody input:checked").parent().parent().remove();
    });

    //add function
    var $add = $("#add");
    var $addTable = $("#addTable");
    var $addTableTr = $("#addTable").find("tr");
    var $addOK = $("#addOK");
    var $showTable = $("#showTable");
    var $addClose = $("#addClose");
    function addMessage(){
        var addString={};
        for(var i=0; i<$addTableTr.length; i++){
            addString[i] = $($addTableTr[i]).find("input").val();
        }
        var strTip;
        strTip = "<tr><td><input type='checkbox'>"+addString[0]+"</td><td>"+addString[1]+"</td><td>"+addString[2]+"</td><td>"+addString[3]+"</td><td>"+addString[4]+"</td></tr>>"
        $(strTip).appendTo($showTable);
        for(var j=0; j<$addTableTr.length; j++){
            $($addTableTr[j]).find("input").val("");
        }
        $addClose.click();
    }
    $addOK.bind("click", function(){
        addMessage();
    });

    //demodulation page
    var $ais_demodulation = $("#ais_demodulation");
    var $demodul = $("#demodul"); //demodulation button in the topbar
    var $demodul_btn = $("#demodul_btn");
    $demodul.bind("click", function(){
        $ais_demodulation.attr("class", "show").siblings().attr("class","hidden");
        $demodul_btn.attr("class", "active").siblings().attr("class", "");
    });
    $demodul_btn.bind("click", function(){
        $ais_demodulation.attr("class", "show").siblings().attr("class", "hidden");
        $demodul_btn.attr("class", "active").siblings().attr("class", "");
    })

    //modulation page
    var $modul_btn = $("#modul_btn");
    var $ais_modulation = $("#ais_modulation");
    $modul_btn.bind("click", function(){
        $ais_modulation.attr("class", "show").siblings().attr("class", "hidden");
        $modul_btn.attr("class", "active").siblings().attr("class", "");
    });

    //analysis page
    var $analy_btn = $("#analy_btn");
    var ais_analysis = $("#ais_analysis");
    $analy_btn.bind("click", function(){
        ais_analysis.attr("class", "show").siblings().attr("class", "hidden");
        $analy_btn.attr("class", "active").siblings().attr("class", "");
    });
});