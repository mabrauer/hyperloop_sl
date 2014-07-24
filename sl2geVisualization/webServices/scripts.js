var GV_MODEL_URL = 
'https://3dwarehouse.sketchup.com/3dw/getpubliccontent?'
+'contentId=d13b07d8-0bd8-4888-af3b-1b2191293202&fn=Hyperloop_Pod.kmz';

var AERIAL_MODEL_URL = 
'https://3dwarehouse.sketchup.com/3dw/getpubliccontent?'
+'contentId=6c86ffc9-f455-4250-9f8a-e11cafb5b9bd&fn=Hyperloop_Disc.kmz';

var TUBE_MODEL_URL = 
'https://3dwarehouse.sketchup.com/3dw/getpubliccontent?'
+'contentId=84cf6775-c44f-47d8-99e6-9be088d78620&fn=Hyperloop_Tube.kmz';

var STATION_MODEL_URL = 
'https://3dwarehouse.sketchup.com/3dw/getpubliccontent?'
+'contentId=a20d27b0-1212-4113-89b6-aef5a0a307f1&fn=Hyperloop_station.kmz'

var INIT_LOC = {
    lat: 38.040675,
    lon: -121.6306,
    heading: 90
}; 

var aKmlVehicle; //kmlObject

var la = new Array; //LookAt

var gvP = new Array; //placemark kmlFeature
var gv = new Array; //ground vehicle kmlGeometry
var gvL = new Array; //ground vehicle location
var gvO = new Array; //ground vehicle orientation

var avP = new Array; //placemark kmlFeature
var av = new Array; //aerial view vehicle kmlGeometry
var avL = new Array; //aerial view vehicle location
var avO = new Array; //aerial view vehicle orientation

var tP = new Array; //placemark kmlFeature
var tG = new Array; //tube kmlGeometry
var tL = new Array; //tube location
var tO = new Array; //tube orientation

var stP = new Array; //placemark kmlFeature
var stG = new Array; //station kmlGeometry
var stL = new Array; //station location
var stO = new Array; //station orientation


var laNr = 0;
var gvNr = 0;
var avNr = 0;
var tNr = 0;
var stNr = 0;


function synchronousUpdate(laI, gvI, avI, tI, stI) {
  // NOTE: google.earth.executeBatch is guaranteed
  // to be synchronous.
  google.earth.executeBatch(ge, function() {
    moveObjects(laI, gvI, avI, tI, stI);
  });
}

function moveObjects(laI, gvI, avI, tI, stI){
    if(laI != -1){
        ge.getView().setAbstractView(la[laI]);
    }

    if(gvI != -1){
        for(var i=0;i<gvNr;i++){
            gv[i].getLocation().setLatLngAlt(gvL[i].getLatitude(), gvL[i].getLongitude(), gvL[i].getAltitude());
            gv[i].getOrientation().set(gvO[i].getHeading(), gvO[i].getTilt(), gvO[i].getRoll());
        }
    }

    if(avI != -1){
        for(var i=0;i<avNr;i++){
            av[i].getLocation().setLatLngAlt(avL[i].getLatitude(), avL[i].getLongitude(), avL[i].getAltitude());
            av[i].getOrientation().set(avO[i].getHeading(), avO[i].getTilt(), avO[i].getRoll());
        }
    }

    if(tI != -1){
        for(var i=0;i<tNr;i++){
            tG[i].getLocation().setLatLngAlt(tL[i].getLatitude(), tL[i].getLongitude(), tL[i].getAltitude());
            tG[i].getOrientation().set(tO[i].getHeading(), tO[i].getTilt(), tO[i].getRoll());
        }
    }

    if(stI != -1){
        for(var i=0;i<stNr;i++){
            stG[i].getLocation().setLatLngAlt(stL[i].getLatitude(), stL[i].getLongitude(), stL[i].getAltitude());
            stG[i].getOrientation().set(stO[i].getHeading(), stO[i].getTilt(), stO[i].getRoll());
        }
    }
}    

function teleportTo(lat, lon, heading){
    var lookAt = ge.createLookAt('');
    lookAt.set(lat, lon, 10, ge.ALTITUDE_RELATIVE_TO_SEA_FLOOR, heading, 80, 50);
    
    ge.getView().setAbstractView(lookAt);

    groundAlt = ge.getGlobe().getGroundAltitude(lat, lon);
}

function addGroundVehicle(){
    google.earth.fetchKml(ge, GV_MODEL_URL, function(kmlObject){
        if (kmlObject){
            ge.getFeatures().appendChild(kmlObject);
            aKmlVehicle = kmlObject;
        }
    });
}

function addAerialVehicle(){
    google.earth.fetchKml(ge, AERIAL_MODEL_URL, function(kmlObject){
        if (kmlObject){
            ge.getFeatures().appendChild(kmlObject);
            aKmlVehicle = kmlObject;
        }
    });
}

function addTube(){
    google.earth.fetchKml(ge, TUBE_MODEL_URL, function(kmlObject){
        if (kmlObject){
            ge.getFeatures().appendChild(kmlObject);
            aKmlVehicle = kmlObject;
        }
    });
}

function addStation(){
    google.earth.fetchKml(ge, STATION_MODEL_URL, function(kmlObject){
        if (kmlObject){
            ge.getFeatures().appendChild(kmlObject);
            aKmlVehicle = kmlObject;
        }
    });
}

function addLaView(range, tilt, altitude){
    la[laNr] = ge.createLookAt('');

//    la[laNr].setAltitudeMode(ge.ALTITUDE_RELATIVE_TO_GROUND);
    la[laNr].setAltitudeMode(ge.ALTITUDE_ABSOLUTE);
    la[laNr].setAltitude(altitude);

    la[laNr].setTilt(tilt);
    la[laNr].setRange(range);

    ge.getView().setAbstractView(la[laNr]);

    laNr = laNr + 1;
}

function addGVModel(lat, lon, heading){
    var placemark = ge.createPlacemark('');
    placemark.setName('GVmodel');
    placemark = addKmlModel(placemark);

    gvP[gvNr] = placemark; //keep separate record to avoid many 'getGeometry()' calls
    gv[gvNr] = placemark.getGeometry();
    gv[gvNr].setAltitudeMode(ge.ALTITUDE_ABSOLUTE);

    gvL[gvNr] = ge.createLocation('');
    gvO[gvNr] = ge.createOrientation('');

    gvL[gvNr].setLatitude(lat);
    gvL[gvNr].setLongitude(lon);
    gvL[gvNr].setAltitude(0);

    gvNr = gvNr + 1;
}

function addAerialModel(lat, lon, heading){
    var placemark = ge.createPlacemark('');
    placemark.setName('AerialModel');
    placemark = addKmlModel(placemark);

    avP[avNr] = placemark; //keep separate record to avoid many 'getGeometry()' calls
    av[avNr] = placemark.getGeometry();
    av[avNr].setAltitudeMode(ge.ALTITUDE_ABSOLUTE);

    avL[avNr] = ge.createLocation('');
    avO[avNr] = ge.createOrientation('');

    avL[avNr].setLatitude(lat);
    avL[avNr].setLongitude(lon);
    avL[avNr].setAltitude(0);

    avNr = avNr + 1;
}

function addTubeModel(lat, lon, alt, heading, tilt){
    var placemark = ge.createPlacemark('');
    placemark.setName('Tube');
    placemark = addKmlModel(placemark);

    tP[tNr] = placemark; //keep separate record to avoid many 'getGeometry()' calls
    tG[tNr] = placemark.getGeometry();
    tG[tNr].setAltitudeMode(ge.ALTITUDE_ABSOLUTE);

    tL[tNr] = ge.createLocation('');
    tO[tNr] = ge.createOrientation('');
    tO[tNr].setHeading(heading);
    tO[tNr].setRoll(tilt); // due to orientation of 3D model, roll is tilt

    tL[tNr].setLatitude(lat);
    tL[tNr].setLongitude(lon);
    tL[tNr].setAltitude(alt);

    tNr = tNr + 1;
}

function addStationModel(lat, lon, heading){
    var placemark = ge.createPlacemark('');
    placemark.setName('Station');
    placemark = addKmlModel(placemark);

    stP[stNr] = placemark; //keep separate record to avoid many 'getGeometry()' calls
    stG[stNr] = placemark.getGeometry();
    stG[stNr].setAltitudeMode(ge.ALTITUDE_ABSOLUTE);

    stL[stNr] = ge.createLocation('');
    stO[stNr] = ge.createOrientation('');

    stL[stNr].setLatitude(lat);
    stL[stNr].setLongitude(lon);

    stNr = stNr + 1;
}

function addKmlModel(placemark){
    walkKmlDom(aKmlVehicle, function() {
        if (this.getType() == 'KmlPlacemark' &&
    //        this.getGeometry() &&
    //        this.getGeometry().getType() == 'KmlModel')
              this.getGeometry())
            placemark = this;
    });

    // add the model placemark to Earth
    ge.getFeatures().appendChild(placemark);
    return placemark;
}

function moveGV(lat, lon, alt, heading, roll, tilt){
    for(var i=0;i<gvNr;i++){
        gvL[i].setLatitude(lat[i]);
        gvL[i].setLongitude(lon[i]);
        gvL[i].setAltitude(alt[i]);
        gvO[i].setHeading(heading[i]);
        gvO[i].setTilt(roll[i]); // due to orientation of 3D model, roll is tilt
        gvO[i].setRoll(tilt[i]);
    }
}

function moveAerialV(lat, lon, alt, heading){
    for(var i=0;i<avNr;i++){
        avL[i].setLatitude(lat[i]);
        avL[i].setLongitude(lon[i]);
        avL[i].setAltitude(alt[i]);
        avO[i].setHeading(heading[i]);
    }
}

function moveTube(i, lat, lon, alt, heading, tilt){
        tL[i].setLatitude(lat);
        tL[i].setLongitude(lon);
        tL[i].setAltitude(alt);
        tO[i].setHeading(heading);
        tO[i].setRoll(tilt); // due to orientation of 3D model, roll is tilt
}

function moveStation(lat, lon, alt, heading, tilt){
    for(var i=0;i<stNr;i++){
        stL[i].setLatitude(lat);
        stL[i].setLongitude(lon);
        stL[i].setAltitude(alt);
        stO[i].setHeading(heading);
        stO[i].setRoll(tilt); // due to orientation of 3D model, roll is tilt
    }
}

function moveLaView(index, lat, lon, alt, head){
    la[index].setLatitude(lat[index]); 
    la[index].setLongitude(lon[index]);
    la[index].setAltitude(alt[index]);
    la[index].setHeading(head[index]); 
//    ge.getView().setAbstractView(la[index]);
}

function moveFullLaView(index, lat, lon, alt, head, tilt, range){
    la[index].setLatitude(lat[index]); 
    la[index].setLongitude(lon[index]);
    la[index].setAltitude(alt[index]);

    la[index].setTilt(tilt[index]);
    la[index].setRange(range[index]);
    la[index].setHeading(head[index]); 

//    ge.getView().setAbstractView(la[index]);
}