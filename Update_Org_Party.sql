-- SET SERVEROUTPUT ON;


/*---------------------+
|  Set Operating Unit  |
+---------------------*/

--*******************************************************
--Use the commands below if running on release 11i    
--Remember to add/remove '--' prior to running        
--*******************************************************

--exec dbms_application_info.set_client_info('204');

--*******************************************************
--Use the commands below if running on release 12     
--Remember to add/remove '--' prior to running        
--*******************************************************

--exec mo_global.init('AR');
--exec mo_global.set_policy_context('S',&orgid);                    --text highlighted in bold take from pre-requiste step 3
--exec fnd_global.apps_initialize(&userid, &Responsibilityid, 222,0); --text highlighted in bold take from pre-requiste step 3

/*------------------+
|  Set Environment  |
+-------------------*/
--set serveroutput on size 1000000;

/*------------------+
|Declarations       |
+-------------------*/

DECLARE
-- API Record Type variable
     p_organization_rec HZ_PARTY_V2PUB.ORGANIZATION_REC_TYPE;
     
-- Standard IN/OUT Parameter
     p_init_msg_list VARCHAR2(1):= FND_API.G_TRUE;
     x_return_status VARCHAR2(240);
     x_msg_count NUMBER;
     x_msg_data VARCHAR2(240);
     p_party_object_version_number NUMBER;
     p_party_id number;
     p_status varchar2(1) :='I';
     p_party_name VARCHAR2(240);
     
-- API output parameter variables
     x_party_id NUMBER;
     x_party_number VARCHAR2(30);
     x_profile_id NUMBER;
     cursor c1 is 
     SELECT
    party_id,
    object_version_number,
    party_name
--INTO
--    p_party_id,
--    p_party_object_version_number,
--    p_party_name
FROM
    hz_parties
WHERE
    party_id in (12911,12917);--'9868'; --'1073';

BEGIN

for i in c1 loop

--Values to pass to API
     p_organization_rec.party_rec.party_id := i.party_id ;--91221;---remember to change this to party want to update
     p_party_object_version_number         := i.object_version_number; ---<OBJECT_VERSION_NUMBER from id. This will increment after run API>
 --- p_organization_rec.created_by_module  := 'TCAPI_EXAMPLE';
     p_organization_rec.party_rec.status :=p_status;
     p_organization_rec.organization_name  :=i.party_name; --'CALIFORNIA HOMEBUILDING FOUNDATION';
--     p_organization_rec.party_rec.category_code := 'PROSPECT';
/*------------------+
|  API to Call      |
+-------------------*/    
     HZ_PARTY_V2PUB.update_organization(
     p_init_msg_list                        => p_init_msg_list,
     p_organization_rec                     => p_organization_rec,
     p_party_object_version_number          => p_party_object_version_number,
     x_return_status                        => x_return_status,
     x_msg_count                            => x_msg_count,
     x_msg_data                             => x_msg_data,
     x_profile_id                           => x_profile_id
     );
/*--------------------------------+
|Result status and error handling |
+--------------------------------*/
    dbms_output.put_line('***************************');
    dbms_output.put_line('Output information ....');
    dbms_output.put_line('return_status= '||x_return_status);
    dbms_output.put_line('msg_count= '||x_msg_count);
    dbms_output.put_line('msg_data= '||x_msg_data);
     
      IF x_msg_count > 1 THEN
       FOR I IN 1..x_msg_count LOOP
        dbms_output.put_line('I.'|| SUBSTR (FND_MSG_PUB.Get(p_encoded =>
        FND_API.G_FALSE ), 1, 255));
      END LOOP;
      END IF;

/*-----------------------------+
|Display API output parameters |
+-----------------------------*/
   dbms_output.put_line('Party_id= '||x_party_id);
   dbms_output.put_line('p_party_object_version_number = '||p_party_object_version_number);
   dbms_output.put_line('Profile_id= '||x_profile_id);
   dbms_output.put_line('Organization_Name='||SUBSTR(p_organization_rec.organization_name,1,255));
---dbms_output.put_line('CreatedBy='||SUBSTR (p_organization_rec.created_by_module,1,255));
   dbms_output.put_line('***************************');

--EXCEPTION
--when others then
  dbms_output.put_line(sqlerrm(sqlcode));
  end loop;
END;
/
--33927030