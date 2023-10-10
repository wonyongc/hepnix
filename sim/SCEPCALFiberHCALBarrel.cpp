//=========================================================================
// Author: Wonyong Chung
//=========================================================================

#define VERBOSE_LEVEL 0

#include "DD4hep/DetFactoryHelper.h"
#include "DD4hep/Printout.h"
#include "XML/Layering.h"
#include "TGeoTrd2.h"
#include "XML/Utilities.h"
#include "DDRec/DetectorData.h"
#include "DDRec/Vector3D.h"
#include "DDSegmentation/Segmentation.h"

using namespace std;

using dd4hep::BUILD_ENVELOPE;
using dd4hep::Box;
using dd4hep::DetElement;
using dd4hep::Detector;
using dd4hep::Layering;
using dd4hep::Material;
using dd4hep::PlacedVolume;
using dd4hep::Position;
using dd4hep::Readout;
using dd4hep::Ref_t;
using dd4hep::RotationZYX;
using dd4hep::Segmentation;
using dd4hep::SensitiveDetector;
using dd4hep::Transform3D;
using dd4hep::Translation3D;
using dd4hep::Trapezoid;
using dd4hep::Tube;
using dd4hep::CutTube;
using dd4hep::EightPointSolid;
using dd4hep::Volume;
using dd4hep::IntersectionSolid;
using dd4hep::_toString;
using dd4hep::rec::Vector3D;

using dd4hep::rec::LayeredCalorimeterData;

static Ref_t create_detector(Detector& theDetector, xml_h e, SensitiveDetector sens)  {

    xml_det_t     x_det     = e;
    int           det_id    = x_det.id();
    string        det_name  = x_det.nameStr();
    DetElement    sdet      (det_name, det_id);

    // --- create an envelope volume and position it into the world ---------------------

    Volume envelope = dd4hep::xml::createPlacedEnvelope(theDetector, e, sdet);
    dd4hep::xml::setDetectorTypeFlag( e, sdet ) ;

    if(theDetector.buildType() == BUILD_ENVELOPE) return sdet;

    //-----------------------------------------------------------------------------------
    dd4hep::xml::Component xmlParameter = x_det.child(_Unicode(parameter));

    const double Rin = xmlParameter.attr<double>(_Unicode(Rmin));
    const double EBz = xmlParameter.attr<double>(_Unicode(EBz));
    const double nomtfw = xmlParameter.attr<double>(_Unicode(nominaltowerfacewidth));
    const double nomfR = xmlParameter.attr<double>(_Unicode(nominalfiberR));
    const double fL = xmlParameter.attr<double>(_Unicode(fiberL));
    const double sThickness = xmlParameter.attr<double>(_Unicode(sThickness));
    const double sGap = xmlParameter.attr<double>(_Unicode(sGap));
    const int nTowersPhi = xmlParameter.attr<double>(_Unicode(nTowersPhi));

    const string region = xmlParameter.attr<string>(_Unicode(region));
    const string cal_limits = xmlParameter.attr<string>(_Unicode(limits));
    const string tRvis = xmlParameter.attr<string>(_Unicode(tRvis));
    const string cCvis = xmlParameter.attr<string>(_Unicode(cCvis));
    const string sTvis = xmlParameter.attr<string>(_Unicode(sTvis));

    Material Brass = theDetector.material(xmlParameter.attr<string>(_Unicode(fiberMaterial)));
//    Material LYSO = theDetector.material(xmlParameter.attr<string>(_Unicode(crystalMaterial)));
//    Material Aluminum = theDetector.material(xmlParameter.attr<string>(_Unicode(instMaterial)));


    double thetaRange = atan(EBz/Rin);

    int nTheta = floor(EBz/nomtfw);
    double dTheta = thetaRange/nTheta;

    int nPhi = nTowersPhi;
    double dPhi = 2*M_PI/nPhi;

    Readout readout = sens.readout();
    Segmentation seg = readout.segmentation();

    std::vector<double> cellSizeVector = seg.segmentation()->cellDimensions(0);
    //Assume uniform cell sizes, provide dummy cellID
    double cell_sizeX      = cellSizeVector[0];
    double cell_sizeY      = cellSizeVector[1];

    Layering      layering (e);
    Material      air       = theDetector.air();
    xml_comp_t    x_staves  = x_det.staves();
    // Create extension objects for reconstruction -----------------

    // Create caloData object to extend driver with data required for reconstruction

    LayeredCalorimeterData* caloData = new LayeredCalorimeterData;
    caloData->layoutType = LayeredCalorimeterData::BarrelLayout;
    caloData->inner_symmetry = nPhi;
    caloData->outer_symmetry = nPhi;

    caloData->inner_phi0 = 0.;
    caloData->outer_phi0 = 0.;

    // One should ensure that these sensitivity gaps are correctly used
    caloData->gap0 = 0;  // the 4 gaps between the 5 towers, along z
    caloData->gap1 = 0; // gaps between stacks in a module, along z
    caloData->gap2 = 0; // gaps where the staves overlap

    // extent of the calorimeter in the r-z-plane [ rmin, rmax, zmin, zmax ] in mm.
    caloData->extent[0] = Rin;
    caloData->extent[1] = Rin+fL; // or r_max ?
    caloData->extent[2] = 0.;      // NN: for barrel detectors this is 0
    caloData->extent[3] = 2*EBz;

    // Compute stave dimensions
    double rStave = Rin/cos(nTheta*dTheta);

    double x0s = rStave*tan(dPhi/2);
    double y0s = rStave*tan(dTheta/2);

    double x1s = rStave*tan(dPhi/2);
    double y1s = rStave*tan(dTheta/2);

    double verticesStave[] = {  x0s,  y0s,
                                x0s, -y0s,
                               -x0s, -y0s,
                               -x0s,  y0s,
                                x1s,  y1s,
                                x1s, -y1s,
                               -x1s, -y1s,
                               -x1s,  y1s };

    EightPointSolid stave(fL/2, verticesStave);

    Volume stave_vol("stave", stave, air);

    sens.setType("calorimeter");

    DetElement stave_det("stave0", det_id);

    LayeredCalorimeterData::Layer caloLayerCrystalsF;
    LayeredCalorimeterData::Layer caloLayerCrystalsR;

    caloLayerCrystalsF.distance = Rin;
    caloLayerCrystalsF.sensitive_thickness       = fL ;
    caloLayerCrystalsF.inner_nRadiationLengths   = 1;
    caloLayerCrystalsF.inner_nInteractionLengths = 1;
    caloLayerCrystalsF.inner_thickness           = fL;
    caloLayerCrystalsF.outer_nRadiationLengths   = 1;
    caloLayerCrystalsF.outer_nInteractionLengths = 1;
    caloLayerCrystalsF.outer_thickness           = fL;
    caloLayerCrystalsF.absorberThickness         = fL;
    caloLayerCrystalsF.cellSize0 = cell_sizeX;
    caloLayerCrystalsF.cellSize1 = cell_sizeY;

    caloLayerCrystalsR.distance = Rin;
    caloLayerCrystalsR.sensitive_thickness       = fL ;
    caloLayerCrystalsR.inner_nRadiationLengths   = 1;
    caloLayerCrystalsR.inner_nInteractionLengths = 1;
    caloLayerCrystalsR.inner_thickness           = fL;
    caloLayerCrystalsR.outer_nRadiationLengths   = 1;
    caloLayerCrystalsR.outer_nInteractionLengths = 1;
    caloLayerCrystalsR.outer_thickness           = fL;
    caloLayerCrystalsR.absorberThickness         = fL;
    caloLayerCrystalsR.cellSize0 = cell_sizeX;
    caloLayerCrystalsR.cellSize1 = cell_sizeY;

    caloData->layers.push_back( caloLayerCrystalsF ) ;
    caloData->layers.push_back( caloLayerCrystalsR ) ;

//    for (int t = -nTheta+1 ; t < nTheta; t++) {
//
//        double r0 = Rin/cos(t*dTheta);
//        double r1 = r0+fL;
//        /*
//        double verticesF[] = {r*tan(dTheta/2), r*tan(dPhi/2),
//                              r*tan(dTheta/2), -r*tan(dPhi/2),
//                              -r*tan(dTheta/2), -r*tan(dPhi/2),
//                              -r*tan(dTheta/2), r*tan(dPhi/2),
//                              (r+Fdz)*tan(dTheta/2), (r+Fdz)*tan(dPhi/2),
//                              (r+Fdz)*tan(dTheta/2), -(r+Fdz)*tan(dPhi/2),
//                              -(r+Fdz)*tan(dTheta/2), -(r+Fdz)*tan(dPhi/2),
//                              -(r+Fdz)*tan(dTheta/2), (r+Fdz)*tan(dPhi/2)};
//
//        double verticesR[] = {(r+Fdz)*tan(dTheta/2), (r+Fdz)*tan(dPhi/2),
//                              (r+Fdz)*tan(dTheta/2), -(r+Fdz)*tan(dPhi/2),
//                              -(r+Fdz)*tan(dTheta/2), -(r+Fdz)*tan(dPhi/2),
//                              -(r+Fdz)*tan(dTheta/2), (r+Fdz)*tan(dPhi/2),
//                              (r+Fdz+Rdz)*tan(dTheta/2), (r+Fdz+Rdz)*tan(dPhi/2),
//                              (r+Fdz+Rdz)*tan(dTheta/2), -(r+Fdz+Rdz)*tan(dPhi/2),
//                              -(r+Fdz+Rdz)*tan(dTheta/2), -(r+Fdz+Rdz)*tan(dPhi/2),
//                              -(r+Fdz+Rdz)*tan(dTheta/2), (r+Fdz+Rdz)*tan(dPhi/2)};
//
//        double verticesC[] = {r*tan(dTheta/2), r*tan(dPhi/2),
//                              r*tan(dTheta/2), -r*tan(dPhi/2),
//                              -r*tan(dTheta/2), -r*tan(dPhi/2),
//                              -r*tan(dTheta/2), r*tan(dPhi/2),
//                              (r+Fdz+Rdz)*tan(dTheta/2), (r+Fdz+Rdz)*tan(dPhi/2),
//                              (r+Fdz+Rdz)*tan(dTheta/2), -(r+Fdz+Rdz)*tan(dPhi/2),
//                              -(r+Fdz+Rdz)*tan(dTheta/2), -(r+Fdz+Rdz)*tan(dPhi/2),
//                              -(r+Fdz+Rdz)*tan(dTheta/2), (r+Fdz+Rdz)*tan(dPhi/2)};
//        */
//
//        double x0 = r0*tan(dPhi/2);
//        double y0 = r0*tan(dTheta/2);
//
//        double x1 = r1*tan(dPhi/2);
//        double y1 = r1*tan(dTheta/2);
//
//        double verticesC[] = {  x0,  y0,
//                                x0, -y0,
//                               -x0, -y0,
//                               -x0,  y0,
//                                x1,  y1,
//                               x1,-y1,
//                              -x1,-y1,
//                              -x1, y1 };
//
//        EightPointSolid crystalsegmentC(fL/2, verticesC);
//
//        int ny = floor(y1/((sqrt(3)*nomfR)));
//        double rmax = y1/(ny*sqrt(3));
//        double rmin = 0.7*rmax;
//
//        int nx = floor(x1/rmax);
//
//        Tube tubeRear(rmin,  rmax, fL/2);
//
//        string cC_name = _toString(t, "crystalC%d");
//        string tR_name = _toString(t, "tubeR%d");
//
//        Volume crystalC(cC_name, crystalsegmentC, air);
//        Volume tubeR(tR_name, tubeRear, Brass);
//
//        tubeR.setSensitiveDetector(sens);
//
//        crystalC.setAttributes(theDetector, region, cal_limits, cCvis);
//        tubeR.setAttributes(theDetector, region, cal_limits, tRvis);
//
//        DetElement tR_det(stave_det, tR_name, det_id);
//
//        for (int j=0; j<2*ny; j++) {
//            double xoffset = rmax*(j%2);
//            double dy = j*sqrt(3)*rmax -y1;
//
//            for (int i=0; i<nx; i++) {
//                double dx = xoffset + i*2*rmax -x1;
//
//
//                Vector3D a1(x1-x0,0,fL);
//                Vector3D b1(0,y1-y0,0);
//                Vector3D n1 = a1.cross(b1);
//
//                Vector3D a2(x1-x0,0,0);
//                Vector3D b2(0,y1-y0,fL);
//                Vector3D n2 = a2.cross(b2);
//
//                double z0 = 0;
//                double z1 = (fL/(x1-x0))*(dx+x1);
//                double z2 = (fL/-(y1-y0))*(dy+y1);
//
//                CutTube cTube1(rmin,rmax, z1/2, 0,2*M_PI, 0,0,1, n1.x(), n1.y(), n1.z());
//                CutTube cTube2(rmin,rmax, z2/2, 0,2*M_PI, 0,0,1, n2.x(), n2.y(), n2.z());
//
//                Volume fiberVol("fiber", IntersectionSolid(cTube1, cTube2), Brass);
//                fiberVol.setSensitiveDetector(sens);
//                fiberVol.setAttributes(theDetector, region, cal_limits, tRvis);
//
//                PlacedVolume tR = crystalC.placeVolume(tubeR, Position( dx, dy, r1-fL/2));
////                PlacedVolume tR = crystalC.placeVolume(fiberVol, Position( dx, dy, r1-fL/2));
//
//                tR.addPhysVolID("layer", t);
//                tR_det.setPlacement(tR);
//            }
//        }
//
//        stave_vol.placeVolume(crystalC, RotationZYX(0, t*dTheta, 0));
//    }

//    stave_det.setVisAttributes(theDetector, x_staves.visStr(), stave_vol);


    // Place the staves
//    for (int i = 0; i < nPhi; i++) { // i is the stave number
////    for (int i = 0; i < 1; i++) { // i is the stave number
//
//        PlacedVolume pv = envelope.placeVolume(stave_vol, RotationZYX(i*dPhi+dPhi/2, M_PI/2, 0));
//        pv.addPhysVolID("module", i);
//
//        DetElement sd = i==0 ? stave_det : stave_det.clone(_toString(i, "stave%d"));
//        sd.setPlacement(pv);
//        sdet.add(sd);
//    }

    Tube soleTube(Rin-sGap-sThickness, Rin-sGap, EBz);
    Volume soleT("soleT", soleTube, Brass);
    soleT.setAttributes(theDetector, region, cal_limits, sTvis);


    PlacedVolume spv = envelope.placeVolume(soleT);
    DetElement solenoid(sdet, "solenoid", det_id);
    solenoid.setPlacement(spv);

    // Set envelope volume attributes
    envelope.setAttributes(theDetector,x_det.regionStr(),x_det.limitsStr(),x_det.visStr());

    sdet.addExtension< LayeredCalorimeterData >( caloData ) ;

    return sdet;
}

DECLARE_DETELEMENT(DRFiberHCALBarrel, create_detector)
