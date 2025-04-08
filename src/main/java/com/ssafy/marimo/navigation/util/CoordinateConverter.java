package com.ssafy.marimo.navigation.util;

import org.locationtech.proj4j.*;

public class CoordinateConverter {

    private static final CRSFactory crsFactory = new CRSFactory();
    private static final CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();

    private static final CoordinateReferenceSystem WGS84 = crsFactory.createFromParameters(
            "WGS84", "+proj=longlat +datum=WGS84 +no_defs"
    );

    private static final CoordinateReferenceSystem TM128 = crsFactory.createFromParameters(
            "TM128",
            "+proj=tmerc +lat_0=38 +lon_0=128 +ellps=bessel +x_0=400000 +y_0=600000 +k=0.9999 +towgs84=-146.43,507.89,681.46"
    );

    public static ProjCoordinate convertWGS84ToTM128(double latitude, double longitude) {
        CoordinateTransform transform = ctFactory.createTransform(WGS84, TM128);
        ProjCoordinate srcCoord = new ProjCoordinate(longitude, latitude); // (lon, lat)
        ProjCoordinate dstCoord = new ProjCoordinate();
        transform.transform(srcCoord, dstCoord);
        return dstCoord;
    }

    // ✅ 새로 추가할 메서드 (TM128 → WGS84)
    public static ProjCoordinate convertTM128ToWGS84(double x, double y) {
        CoordinateTransform transform = ctFactory.createTransform(TM128, WGS84);
        ProjCoordinate srcCoord = new ProjCoordinate(x, y); // (x, y)
        ProjCoordinate dstCoord = new ProjCoordinate();
        transform.transform(srcCoord, dstCoord);
        return dstCoord;
    }
}
