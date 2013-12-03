// Location.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline


package com.depthfirstdesign.driveline.model;

import javax.xml.bind.annotation.*;

@XmlRootElement(name = "Location")
public class Location {
  private float longitude;

    public float getLatitude() {
        return latitude;
    }

    public void setLatitude(float latitude) {
        this.latitude = latitude;
    }

    private float latitude;

  @XmlElement(name = "id")
  public float getLongitude() {
    return longitude;
  }

  public void setLongitude(float longitude) {
    this.longitude = longitude;
  }
}