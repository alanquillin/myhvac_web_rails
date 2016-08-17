var timer;
var tempGage = null;
var dashboardPaths = [];
var autoRefresh = true;

function updateSystemDetails(){
    console.log('Retrieving system details...');
    return $.ajax({
        type: "GET",
        url: "/dashboard.js"
    }).error(function(jqXHR, textStatus, errorThrown){
        if(jqXHR.status>0){
            setdashboardErrorMsg(textStatus + ' (' + errorThrown + ')');
        }
        else{
            setdashboardErrorMsg('Unable to connect to the service... Connection refused');
        }
        $('#dashboardError').show();
        setUpdateSystemDetailsTimer(60000);
    });
}

function setdashboardErrorMsg(msg){
    console.log('Balz... Last call to system failed: ' + msg)
    $('#dashboardErrorMessage').text(msg);
    $('#dashboardErrorTime').text(new Date().toLocaleString());
}

function setTempGage(temp){
    console.log('Setting the temp guage to:' + temp)
    if(tempGage == null){
        tempGage = new JustGage({
            id: 'gauge',
            value: temp,
            min: 30,
            max: 100,
            title: 'Aggregate Temp',
            levelColors: ['#c1e2b3', '#2b542c'],
            //levelColors: ['#3c763d', '#2b542c', '#dff0d8', '#c1e2b3', '#d0e9c6'],
            symbol: '° F',
            shadowOpacity: .2,
            startAnimationTime: 1000,
            startAnimationType: 'bounce',
            refreshAnimationType: 'bounce',
            decimals: 1,
            gaugeWidthScale:.5
        });
    }
    else{
        tempGage.refresh(temp);
    }
}

function showSensorMeasurementModal(sensor_id){
    $('#roomTempHistory').modal('show');
    initSenorMeasurementGrip(sensor_id);
}

function setUpdateSystemDetailsTimer(timeout){
    timeout = typeof timeout !== 'undefined' ? timeout : 25000;
    var isDashboard = false;

    for(i = 0; i < dashboardPaths.length; i++){
        if(window.location.pathname == dashboardPaths[i]){
            isDashboard = true;
        }
    }

    if(isDashboard == true && autoRefresh == true) {
        timer = setTimeout(updateSystemDetails, timeout);
    }
}