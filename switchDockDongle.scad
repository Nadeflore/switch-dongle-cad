$fs = 0.3;

wallThickness = 1.5;
pcbX = 65;
insideY = 74.5;

// Defines pcb position
bottomLeftHoleX = 6 + wallThickness;
bottomLeftHoleY = 4.5 + wallThickness;

// Relative holes positions
bottomHolesXGap = 52.7;
rightHolesYGap = 57.4;
leftHolesYGap = 61.2;
leftHolesXGap = 10;

extraHoleBottomXGap = 5.7;
extraHoleTopXGap = 2.1;
extraHoleTopYGap = 45.4;

// bottom plate specs
bottomPlateX = pcbX + 2 * wallThickness;
bottomPlateY = insideY + 2 * wallThickness ;// was 77
bottomPlateZ = 1.5;

// Holes specs
holesHeight = 9;
holesExternalDiameter = 4.5;
holesInternalDiameter = 2;
holeGussetlength = 4;
holeGussetThickness = 1;

// dimensions
pcbThickness = 1;
pcbTopClearance = 3;
boxHeight = bottomPlateZ + holesHeight + pcbThickness + pcbTopClearance;




// Pcb screw holes
module pcbScrewHoles() {
    // Bottom left hole
    translate([bottomLeftHoleX, bottomLeftHoleY, bottomPlateZ]) {
        rotate([0, 0, 180]) {
            screwHole(gusset1=4.2, gusset2=3, gusset3=1);
        }
    }

    // Bottom right hole
    translate([bottomLeftHoleX + bottomHolesXGap, bottomLeftHoleY, bottomPlateZ]) {
        rotate([0, 0, 180]) {
            screwHole(gusset2=3, gusset3=4.2);
        }
    }

    // Top right hole
    translate([bottomLeftHoleX + bottomHolesXGap, bottomLeftHoleY + rightHolesYGap, bottomPlateZ]) {
        screwHole(gusset1=4.2, gusset2=2.8);
    }

    // Top left hole
    translate([bottomLeftHoleX + leftHolesXGap, bottomLeftHoleY + leftHolesYGap, bottomPlateZ]) {
        screwHole(gusset2=7, gusset3=14);
    }
    
    // Bottom extra hole
    translate([bottomLeftHoleX + extraHoleBottomXGap, bottomLeftHoleY, bottomPlateZ]) {
        rotate([0, 0, 180]) {
            screwHole(gusset1=1, gusset2=3);
        }
    }
    
    // Top extra hole
    translate([bottomLeftHoleX + extraHoleTopXGap, bottomLeftHoleY + extraHoleTopYGap, bottomPlateZ]) {
        rotate([0, 0, 180]) {
            screwHole(gusset1=7, gusset2=0);
        }
    }
}

module screwHole(gusset1=holeGussetlength, gusset2=holeGussetlength, gusset3=holeGussetlength) {
        difference() {
        // External
        cylinder(h=holesHeight, d=holesExternalDiameter);
        // Internal
        cylinder(h=holesHeight+1, d=holesInternalDiameter);
    }
    
    // Gussets
    for(angle=[0, 90, 180]) {
        length = angle==0 ? gusset1 : (angle==90 ?gusset2 : gusset3);
        
        rotate([0, 0, angle]) {
            translate([holesInternalDiameter/2, -holeGussetThickness/2, 0]) {
                cube([length + (holesExternalDiameter-holesInternalDiameter)/2, holeGussetThickness, holesHeight]);
            }
        }
    }
}



// Connectors plate

// Usb-c Connector dimension
usbcW = 9;
usbcH = 3;
topLeftHoleToUsbcEdge = 2.8;

usbcCenterY = bottomLeftHoleY + leftHolesYGap - (topLeftHoleToUsbcEdge + usbcW/2);
usbcCenterZ = bottomPlateZ + holesHeight - usbcH/2;

// Usb connector dimensions
usbW = 13;
usbH = 5.6;

usbcToUsbYGap = 19.2;
usbcToUsbZGap = 2.5;

// Hdmi connector dimensions

hdmiW = 15;
hdmiH = 5.3;
hdmiHsmall = 3.2;
hdmiWsmall = 10.7;

usbToHdmiYGap = 21.1;
usbToHdmiZGap = 0.9 ;

module connectorsPanelHoles() {
    // Usb-c hole
    translate([0, usbcCenterY, usbcCenterZ]) {
            usbcConnector();
    }
    
    // Usb hole
    translate([0, usbcCenterY - usbcToUsbYGap, usbcCenterZ - usbcToUsbZGap]) {
        cube([10, usbW, usbH], center=true);
    }
    
    // Hdmi hole
    translate([0, usbcCenterY - usbcToUsbYGap - usbToHdmiYGap, usbcCenterZ - usbcToUsbZGap + usbToHdmiZGap]) {
        hdmiConnector();
    }
}

module usbcConnector() {
    rotate([0, 90, 0]) {
        hull() {
            for (i=[-1, 1]) {
                translate([0, i*(usbcW-usbcH)/2, 0]) {
                    cylinder(h=10, d=usbcH, center=true);
                }
            }
        } 
    }
}

module hdmiConnector() {
    hull() {
        translate([0, 0, hdmiHsmall/2 - hdmiH/2]) {
            cube([10, hdmiW, hdmiHsmall], center=true);
        }
        translate([0, 0, hdmiHsmall/2] ) {
            cube([10, hdmiWsmall, hdmiH - hdmiHsmall], center=true);
        }
    }
}



// led hole and led pcb support

ledHoleZpos = 2.8 + bottomPlateZ;
ledHoleZ = 1.6;
ledHoleX = 6.5;
ledHoleY = 4.8;

ledPlasticInnerPartX = 5;
ledPlasticInnerPartY = 4;

ledPcbZ = 9;
ledPcbX = 9.8;
ledPcbThickness = 1.3;
ledPcbToPlasticGap = 1;

ledPcbHolderThickness = 1;
ledPcbHolderHeight = 2.5;

// led hole support dimensions
ledHoleSupportWidth=0.5;
// hole thickness margin
ledHoleWallThicknessMargin=10;

ledWallThickness = 2;

// Thicker walls for led part
module ledWalls() {
    translate([bottomPlateX, bottomPlateY, 0]) {
        union() {
            translate([-(ledHoleX + ledHoleWallThicknessMargin), -ledWallThickness, 0]) {
                cube([ledHoleX + ledHoleWallThicknessMargin, ledWallThickness, boxHeight]);
            }

            translate([-ledWallThickness, -(ledHoleY + ledHoleWallThicknessMargin), 0]) {
                cube([ledWallThickness, ledHoleY + ledHoleWallThicknessMargin, boxHeight]);
            }
        }
        
    }
}

module ledHole() {
    translate([bottomPlateX, bottomPlateY, 0]) {            
        translate([-ledHoleX, 0, ledHoleZpos]) { 
            rotate([0, 0, -45]) {
                translate([0, -5, 0]) {
                    cube([cos(45)*ledHoleX - ledHoleSupportWidth/2, 10, ledHoleZ]);
                }
            }
        }
        
        translate([0, -ledHoleY, ledHoleZpos]) { 
            rotate([0, 0, 135]) {
                translate([0, -5, 0]) {
                    cube([cos(45)*ledHoleY - ledHoleSupportWidth/2, 10, ledHoleZ]);
                }
            }
        }
    }
}

module ledPcbHolder() {
    translate([bottomPlateX, bottomPlateY, 0]) { 
        // bottom part
        translate([-(ledWallThickness + ledPcbX + ledPcbHolderThickness), -(ledWallThickness + ledPlasticInnerPartY + ledPcbToPlasticGap + ledPcbThickness + ledPcbHolderThickness), bottomPlateZ]) {
            cube([ledPcbHolderThickness, ledPcbThickness + ledPcbHolderThickness, ledPcbHolderHeight]);
            cube([3*ledPcbHolderThickness, ledPcbHolderThickness, ledPcbHolderHeight]);
            translate([0, ledPcbHolderThickness + ledPcbThickness, 0]) {
                cube([3*ledPcbHolderThickness, ledPcbHolderThickness, ledPcbHolderHeight]);
            }
        }
        
        
         // top part
        translate([ -(ledWallThickness + ledPcbHolderThickness),  -(ledWallThickness + ledPlasticInnerPartY + ledPcbToPlasticGap + ledPcbThickness + ledPcbHolderThickness), bottomPlateZ + ledPcbZ - ledPcbHolderHeight]) {
            translate([0, 0, - (ledPcbZ - ledPcbHolderHeight)]){
                cube([ledPcbHolderThickness, ledPcbHolderThickness, ledPcbZ]);
            }
            translate([0, ledPcbHolderThickness + ledPcbThickness, 0]) {
                cube([ledPcbHolderThickness, ledPcbHolderThickness, ledPcbHolderHeight]);
            }
        }
    }
}


// Switch usb-c connector
switchScrewHolesDistance = 15.6;
switchScrewHolesExternalDiameter = 3;
switchScrewHolesInternalDiameter = 1.5;
switchScrewHolesHeight = 3.5;

switchScrewGussetLength = 3.1;
switchScrewGussetThickness = 1;
switchScrewGussetTopClearance = 1;

wallToSwitchScrewDistance = 4.5;

SwitchScrewPositionX = bottomPlateX/2 + 3;

module switchUsbcConnector() {    
    translate([SwitchScrewPositionX, bottomPlateY - wallThickness - wallToSwitchScrewDistance, bottomPlateZ]) {
        for(i=[-1,1]) {
            translate([switchScrewHolesDistance/2 * i, 0, 0]) {
                difference() {
                    // External
                    cylinder(h=switchScrewHolesHeight, d=switchScrewHolesExternalDiameter);
                    // Internal
                    cylinder(h=switchScrewHolesHeight+1, d=switchScrewHolesInternalDiameter);
                }
                
                for(angle=[0, 90, 180, -90]) {
                    rotate([0, 0, angle]) {
                        translate([switchScrewHolesInternalDiameter/2, -switchScrewGussetThickness/2, 0]) {
                            cube([switchScrewGussetLength + (switchScrewHolesExternalDiameter-switchScrewHolesInternalDiameter)/2, holeGussetThickness, switchScrewHolesHeight - switchScrewGussetTopClearance]);
                        }
                    }
                }
            }
        }
    }
}


// Usb panel holes

usbGap = 7;
usbPcbGap = 1;
usbBottomHoleGap = 3.7;

module usbPanelHoles() {
    translate([bottomPlateX - wallThickness, 0, 0]) {
        for(i=[0, usbGap + usbW]) {
            translate([0, bottomLeftHoleY + usbBottomHoleGap + usbW/2 + i, bottomPlateZ + holesHeight - usbH/2 - usbPcbGap]) {
                cube([10, usbW, usbH], center=true);
            }
        }
    }
}




// lid part
lidZ = 1.5;
lidHoleInternalDiameter = 2.5;
lidHoleExternalDiameter = 6;
lidHoleHeadDiameter = 4;
lidHoleHeadDepth = 2;

usbcLidHoleDimensionX = 15;
usbcLidHoleDimensionY = bottomPlateY - (wallThickness + bottomLeftHoleY + leftHolesYGap);


module lid() {
    mirror([1, 0, 0]) {
        difference() {
            union() {
                roundedBox([bottomPlateX, bottomPlateY, lidZ], [0.1, 1.5], 5);
                lidHoles(emptyPart=false);
            }
            lidHoles(emptyPart=true);
            usbcLidHole();
        }
    }
}

module lidHoles(emptyPart=false) {
    // Bottom left hole
    translate([bottomLeftHoleX, bottomLeftHoleY, 0]) {
        lidHole(emptyPart);
    }

    // Bottom right hole
    translate([bottomLeftHoleX + bottomHolesXGap, bottomLeftHoleY, 0]) {
        lidHole(emptyPart);
    }

    // Top right hole
    translate([bottomLeftHoleX + bottomHolesXGap, bottomLeftHoleY + rightHolesYGap, 0]) {
        lidHole(emptyPart);
    }

    // Top left hole
    translate([bottomLeftHoleX + leftHolesXGap, bottomLeftHoleY + leftHolesYGap, 0]) {
        lidHole(emptyPart);
    }
}

module lidHole(emptyPart=false) {
    if (emptyPart) {
        cylinder(h=20, d=lidHoleInternalDiameter, center=true);
        translate([0, 0, -1]) {
            cylinder(h=lidHoleHeadDepth + 1, d=lidHoleHeadDiameter);
        }
    } else {
        cylinder(h=lidZ + pcbTopClearance, d=lidHoleExternalDiameter);
    }
}

module usbcLidHole() {
    translate([SwitchScrewPositionX, bottomPlateY - wallThickness - wallToSwitchScrewDistance, 0]) {
        hull() {
            for(i=[-1,1]) {
                translate([i * (usbcLidHoleDimensionY-usbcLidHoleDimensionX)/2, 0, 0]) {
                    cylinder(h=10, d=usbcLidHoleDimensionY, center=true);
                }
            }
        }
    }
}


// enclosure box case
module case() {
    difference() {
        roundedBox([bottomPlateX, bottomPlateY, boxHeight], [0.1, 2], 5);
        translate([wallThickness, wallThickness , bottomPlateZ]) {
             roundedBox([bottomPlateX - 2*wallThickness, bottomPlateY - 2*wallThickness, boxHeight], [0.1, 2], 5);
        }
    }
}

module roundedBox(dimensions, horizontalEdgesRadiuses, verticalEdgesRadius, center=false) {
    translate(dimensions/2 * (center == true ? 0 : 1)) {
        hull() {
            for (x=[0, 1]) {
                for (y=[0, 1]) {
                    for (z=[0, 1]) {
                        mirror([x, 0, 0]) {
                            mirror([0, y, 0]) {
                                mirror([0, 0, z]) {
                                    horizontalEdgesRadius = horizontalEdgesRadiuses[z];
                                    cornerCenterPosition = [dimensions[0]/2 - verticalEdgesRadius, dimensions[1]/2 - verticalEdgesRadius, dimensions[2]/2 - horizontalEdgesRadius];

                                    translate(cornerCenterPosition) {
                                        // corner
                                        rotate_extrude_90deg()
                                            translate([verticalEdgesRadius - horizontalEdgesRadius, 0, 0])
                                                quarter_circle(r = horizontalEdgesRadius);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    module quarter_circle(r=3.0) {
      intersection() {
        circle(r=r);
        square(r);
      }
    }
    
    module rotate_extrude_90deg() {
        intersection() {
            rotate_extrude() children();
            cube(100);
        }
    }
}


union() {
    difference() {
        union() {
            // Solid enclosure parts
            case();
            *ledWalls();
        }
        
        // Holes in enclosure
        connectorsPanelHoles();
        usbPanelHoles();
        ledHole();
    }
    
    // Extra solid parts
    pcbScrewHoles();
    ledPcbHolder();
    switchUsbcConnector();
    
}

// lid
translate([-10, 0, 0]) {
    lid();
}
