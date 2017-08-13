using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class CameraScript : MonoBehaviour {

    //   public GameObject target;

    //// Use this for initialization
    //void Start () {

    //}

    //// Update is called once per frame
    //void Update () {
    //       transform.Translate(Vector3.right);
    //       transform.Translate(Vector3.forward);
    //       transform.LookAt(target.transform);
    //}

    //public GameObject target;
    //public float speed = 1f;
    //private float distance;
    //private float currentAngle = 0;

    //void Start()
    //{
    //    distance = (new Vector3(transform.position.x, 0, transform.position.z)).magnitude;
    //}

    //void Update()
    //{
    //    currentAngle += Input.GetAxis("Horizontal") * speed * Time.deltaTime;

    //    Quaternion q = Quaternion.Euler(0, currentAngle, 0);
    //    Vector3 direction = q * Vector3.right;
    //    transform.position = target.transform.position - direction * distance + new Vector3(transform.position.x, 0,0);

    //    transform.LookAt(target.transform.position);
    //}

    public GameObject target;//the target object
    private float speedMod = 3.0f;//a speed modifier
    private Vector3 point;//the coord to the point where the camera looks at

    private float delta = 0f;

    void Start()
    {//Set up things on the start method
        point = target.transform.position;//get target's coords
        transform.LookAt(point);//makes the camera look to it
    }

    void Update()
    {//makes the camera rotate around "point" coords, rotating around its Y axis, 20 degrees per second times the speed modifier
        transform.RotateAround(point, new Vector3(0.0f, -1.0f, 0.0f), 20 * 0.05f /*delta*/ * speedMod);
        delta += 0.01f;
    }
}
