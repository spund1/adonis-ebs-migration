DECLARE
  l_party_site_rec hz_party_site_v2pub.PARTY_SITE_REC_TYPE;
  l_obj_num        NUMBER;
  l_return_status  VARCHAR2(1);
  l_msg_count      NUMBER;
  l_msg_data       VARCHAR2(2000);
  p_party_site_id number;
   p_status varchar2(1) :='I';
   p_site_object_version_number number;
   cursor c1 is 
   SELECT
    b.PARTY_SITE_ID,
    b.object_version_number
--INTO
--    p_party_site_id,
--    p_site_object_version_number
FROM
    hz_parties a,
    HZ_PARTY_SITES b
WHERE
    A.PARTY_ID IN (12911,12917)
    and a.PARTY_ID=b.PARTY_ID;
BEGIN

for i in c1 loop

  l_party_site_rec.party_site_id            := i.party_site_id; --p_party_site_id; --10806693;
  l_party_site_rec.status                   := p_status; 
  l_obj_num                                 := i.object_version_number; --p_site_object_version_number; --1;
  
  hz_party_site_v2pub.update_party_site
  ( p_init_msg_list         =>  FND_API.G_FALSE
  , p_party_site_rec        =>  l_PARTY_SITE_REC
  , p_object_version_number => l_obj_num
  , x_return_status         => l_return_status
  , x_msg_count             => l_msg_count
  , x_msg_data              => l_msg_data
  ) ;
  dbms_output.put_line('Ret Status:' || l_return_status);
  end loop;
END;
/