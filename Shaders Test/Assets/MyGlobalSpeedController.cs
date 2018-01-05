using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class MyGlobalSpeedController
{
    private static MyGlobalSpeedController instance = null;
    public static MyGlobalSpeedController SharedInstance
    {
        get
        {
            if (instance == null)
            {
                instance = new MyGlobalSpeedController();
            }
            return instance;
        }
    }
    public float speed;
    public float phase;
    public float position;
}
