SELECT "DPS Number"
                   AS dps_number,
               "CALL Type",
               "Country",
               "BTT Name",
               "Location",
               "Service Tag",
               "Service Tag Received",
               "Technology",
               CASE
                   WHEN "Unit Delivery Date" IS NOT NULL
                   THEN
                       'Closed'
                   WHEN "Delivery TR" IS NOT NULL
                   THEN
                       'Appointment Out'
                   WHEN "ERWC Date" IS NOT NULL
                   THEN
                       'Shipping'
                   WHEN "hold status" IS NOT NULL
                   THEN
                       "hold status"
                   WHEN    "Released_from_hold" IS NOT NULL
                        OR "Debug_time_out" IS NOT NULL         /*MG20150326*/
                   THEN
                       'Repair'
                   WHEN "Diagnosis" IS NOT NULL
                   THEN
                       "Diagnosis"
                   WHEN "Fusion" IS NOT NULL
                   THEN
                       "Fusion"
                   WHEN "Current Exception code" IN
                            ('INI - Insufficient Information',
                             'INC - Incorrect Customer details')
                   THEN
                       'TS Delay'
                   WHEN "Pick up TR" IS NOT NULL AND "BTT Name" = 'AX'
                   THEN
                       'Empty box ship'
                   WHEN "Unit collection date" IS NOT NULL
                   THEN
                       'Pickup in Progress'
                   WHEN "Order Status" = 'Released'
                   THEN
                       'Appointment In'
                   WHEN "Order Status" = 'Firm'
                   THEN
                       'RMA creation'
                   ELSE
                       NULL
               END
                   AS "Dell Status",
               "Debug_time_out",
               "Released_from_hold",
               "hold status",
               CASE
                   WHEN "Unit Delivery Date" IS NOT NULL
                   THEN
                       1
                   WHEN "Delivery TR" IS NOT NULL
                   THEN
                       2
                   WHEN "ERWC Date" IS NOT NULL
                   THEN
                       3
                   WHEN    "Released_from_hold" IS NOT NULL
                        OR "Debug_time_out" IS NOT NULL           --MG20150326
                   THEN
                       4
                   WHEN     "hold status" IS NOT NULL
                        AND "hold status" != 'Discrepant Receipt'
                   THEN
                       5
                   WHEN "Diagnosis" IS NOT NULL
                   THEN
                       6
                   WHEN "hold status" = 'Discrepant Receipt'
                   THEN
                       7
                   WHEN "Fusion" IS NOT NULL
                   THEN
                       8
                   WHEN "Unit collection date" IS NOT NULL
                   THEN
                       9
                   WHEN "Current Exception code" IN
                            ('INI - Insufficient Information',
                             'INC - Incorrect Customer details')
                   THEN
                       10
                   WHEN "Pick up TR" IS NOT NULL AND "BTT Name" = 'AX'
                   THEN
                       11
                   WHEN "Order Status" = 'Released'
                   THEN
                       12
                   WHEN "Order Status" = 'Firm'
                   THEN
                       13
                   ELSE
                       14
               END
                   AS "in the order",
               "Order Status",
               "Model Number",
               ROUND ("Unit collection date" - "prev_shp_timestamp")
                   AS "Number of Days RR",
               CASE
                   WHEN     ROUND (
                                "Unit collection date" - "prev_shp_timestamp")
                                IS NOT NULL
                        AND ROUND (
                                "Unit collection date" - "prev_shp_timestamp") <=
                            30
                   THEN
                       'YES'
                   ELSE
                       'NO'
               END
                   AS "Repeat",
               /*                        ROUND (report_net.calc_working_days_by_client (
                                                 "Call Create Date",
                                                 NVL ("Ship and Closed Date", SYSDATE),
                                                 "Country",
                                                 'DELL'))
                                          AS "TAT without exe code to ship",
                                       ROUND (report_net.calc_working_days_by_client (
                                                 "Call Create Date",
                                                 NVL ("Unit Delivery Date", SYSDATE),
                                                 "Country",
                                                 'DELL'))
                                          AS "TAT without exe code to POD", must be calculated  during sllection */
               SUBSTR ("Pick up TR", 0, 400)
                   "Pick up TR",
               "Call Create Date",
               "Unit collection date",
               "Unit Arrival to Depot Date",
               "Part Request Date",
               "Ship and Closed Date",
               CASE
                   WHEN "Unit Delivery Date" <= SYSDATE /*MG20180613 dodane ukrywanie daty z przyszoci*/
                   THEN
                       TRUNC ("Unit Delivery Date")
                   ELSE
                       NULL
               END
                   AS "Unit Delivery to Customer Date",
               /*trunc("Unit Delivery Date") AS "Unit Delivery to Customer Date",*/
               "Delivery TR",
               eb_tr,
               eb_rtr,
               "Ordered parts",
               "Parts used",
               "Technican ID",
               "First Exception code",
               "Last Exception code",
               "Current Exception code"/*HOLD DAYS Quantity source report*/
                                       ,
               awaiting_part,
               awaiting_part_swap,
               awaiting_engineering_qa,
               warranty_issue_ber,
               awaiting_engineering_doa,
               awaiting_engineering_egh,
               awaiting_engineering_tag,
               awaiting_engineering_ops,
               awaiting_engineering_dell,
               customer_ddp,
               customer_adm,
               customer_mbr,
               customer_nff,
               customer_nff2,
               warranty_issue_ctp/*RO with Address  Details */
                                 ,
               reference_order,
               ro_note/*                                ,CUSTOMER_ID*/
                      ,
               customer_name,
               address_line1,
               address_line2,
               address_line3,
               city/*                                ,STATE*/
                   ,
               postal_code,
               customer_country/*                                ,ISO_COUNTRY_CODE*/
                               ,
               phone_no,
               original_customer,
               internal_notes,
               type_of_contact,
               nff_spec_acces,
               wi_disposition,
               unit_bcn--                                ,SERIAL_NO
                       ,
               part_no,
               part_desc,
               hold_status--                                ,REASON_FOR_HOLD
                          ,
               storage_hold_code,
               storage_hold_code_desc,
               current_workcenter,
               destination_workcenter,
               last_update,
               workorder_id,
               wo_created_timestamp,
               client_reference_no2,
               bin,
               product_class,
               put_on_hold_date,
               released_from_hold_date,
               invtorynotes,
               date_ro_released,
               activity_creator_group,
               additional_information,
               wi_dysp,
               wi_other_inf,
               wi_fusion,
               fusion_created_date,
               service_event,
               service_status,
               itemid,
               paid_psa,
               action_code,
               bcn_call,
               SUBSTR (what_parts_issued, 0, 200)
                   what_parts_issued/*,WHAT_PARTS_ISSUED*/
                                    ,
               SUBSTR (what_parts_removed, 0, 200)
                   what_parts_removed/*,WHAT_PARTS_REMOVED*/
                                     ,
               ro_update,
               "Retailer",
               "ENTITLEMENT",
               SUBSTR ("IB_AWB_1", 0, 250)
                   AS "IB_AWB_1",
               SUBSTR ("IB_AWB_2", 0, 250)
                   AS "IB_AWB_2",
               SUBSTR ("IB_AWB_3", 0, 250)
                   AS "IB_AWB_3",
               SUBSTR ("IB_AWB_4", 0, 250)
                   AS "IB_AWB_4",
               SUBSTR ("IB_AWB_5", 0, 250)
                   AS "IB_AWB_5",
               SUBSTR ("OB_AWB_1", 0, 250)
                   AS "OB_AWB_1",
               SUBSTR ("OB_AWB_2", 0, 250)
                   AS "OB_AWB_2",
               SUBSTR (inbound_service, 0, 25)
                   AS inbound_service,
               incident_id,
               nff_def_freq/*,DPD_EMPTY_BOX_AWB*/
                           ,
               REGEXP_REPLACE (dpd_empty_box_awb, '[^[:digit:]]')
                   AS dpd_empty_box_awb /* MG20230425 INC with char in numbers*/
                                       ,
               SUBSTR (second_inbound_awb, 0, 400)
                   AS second_inbound_awb
          FROM (SELECT                                            --"PART_NO",
                                                                 --"UNTI_BCN",
                     "DPS Number",
                     "CALL Type",
                     "Country",
                     "BTT Name",
                     "Location",
                     "Service Tag",
                     "Service Tag Received",
                     "Technology",
                     "Model Number",
                     "Order Status",
                     "Pick up TR",
                     "Call Create Date",
                     CASE
                         WHEN "Country" = 'GB'          /*MG20221026 adding */
                         THEN
                             (SELECT MIN (unit_collection_date)    AS unit_collection_date
                               FROM (SELECT --dp.*,
                                            TO_DATE (
                                                event_date || ' ' || event_time,
                                                'dd-mm-yyyy hh24:mi')    AS unit_collection_date
                                       FROM rpa.glo_cem_events_dpduk dp
                                      WHERE     1 = 1
                                            AND dp.parcel_number =
                                                REGEXP_REPLACE ("Pick up TR",
                                                                '[^[:digit:]]') --konieczny regexp bo ogï¿½lnie w kontekscie zdarzaja sie trackingi z literami  --'15501736907731' --
                                            --select regexp_replace('15501736907731','[^[:digit:]]') from dual
                                            AND (   event_code = 70
                                                 OR event_code = 9
                                                 OR event_code = 62
                                                 OR event_code = 39)))
                         WHEN "Country" IN ('FR', 'DE') /*MG20221026 adding */
                         THEN
                             (SELECT MIN (geh.event_timestamp)
                               FROM b2b.delltadepotemea_gls_event_history geh
                                    JOIN b2b.delltadepotemea_gls_event_matrix gem
                                        ON geh.scan_code = gem.event_reason
                              WHERE     geh.tracking_number = "Pick up TR" /*dcs.pick_up_tr*/
                                    AND gem.collection_flag = 'Y') /*MG20231130 adding follow by [RR][RT][GEO-DT-FF][BYD]Dell Car GLS Report*/
                         ELSE
                             (SELECT MIN (ttl.pickup_date)
                                FROM report_net.trax_tracking_lookup_vw ttl
                               WHERE ttl.tracking_number = "Pick up TR")
                     END
                         AS "Unit collection date",
                     "Unit Arrival to Depot Date",
                     "Part Request Date",
                     "ERWC Date",
                     "hold status",
                     "Fusion",
                     "Diagnosis",
                     "Debug_time_out",
                     "Released_from_hold",
                     "Ship and Closed Date",
                     COALESCE (
                         CASE
                             WHEN "Country" IN ('CH')
                             THEN
                                 (SELECT client_ext.wizq_add_wd (
                                             "Ship and Closed Date",
                                             1,
                                             "Country")
                                   FROM DUAL)
                             WHEN "Country" IN ('NO', 'FI')
                             THEN
                                 (SELECT client_ext.wizq_add_wd (
                                             "Ship and Closed Date",
                                             2,
                                             "Country")
                                   FROM DUAL)
                             /*when "Country" in ('NO','SE','FI' ) then "Ship and Closed Date"+2 /*MG20200424*/
                             WHEN "Country" IN ('GB') /*MG20221026 adding GB DPD*/
                             THEN
                                 (SELECT MIN (unit_delivery_to_customer_date)    unit_delivery_to_customer_date
                                   FROM (SELECT --dp.*,
                                                TO_DATE (
                                                       event_date
                                                    || ' '
                                                    || event_time,
                                                    'dd-mm-yyyy hh24:mi')    AS unit_delivery_to_customer_date
                                           FROM rpa.glo_cem_events_dpduk dp
                                          WHERE     1 = 1
                                                AND dp.parcel_number =
                                                    REGEXP_REPLACE (
                                                        "Delivery TR",
                                                        '[^[:digit:]]')
                                                AND (event_code = 1)))
                             ELSE
                                 (SELECT MIN (ttl.delivered_date)
                                    FROM report_net.trax_tracking_lookup_vw ttl
                                   WHERE ttl.tracking_number = "Delivery TR")
                         END,
                         (SELECT delivered_date
                            FROM gbyddellcarsynergy.dell_car_logistics_delivery
                           WHERE tracking = "Delivery TR"),
                         (SELECT MAX (geh.event_timestamp)
                           FROM b2b.delltadepotemea_gls_event_history geh
                                JOIN b2b.delltadepotemea_gls_event_matrix gem
                                    ON geh.scan_code = gem.event_reason
                          WHERE     geh.tracking_number = "Delivery TR" /*dcs.delivery_tr*/
                                AND gem.pod_flag = 'Y') /*MG20231130 adding follow by [RR][RT][GEO-DT-FF][BYD]Dell Car GLS Report*/
                                                       )
                         AS "Unit Delivery Date", /*MG20240125 code from DELL CAR REPORT */
                     "Delivery TR",
                     eb_tr,
                     eb_rtr,
                     "Ordered parts",
                     "Parts used",
                     "Technican ID",
                     "First Exception code",
                     "Last Exception code",
                     /*"Last Exception code new",*/
                     "Current Exception code",
                     "prev_shp_timestamp",
                     awaiting_part,
                     awaiting_part_swap,
                     awaiting_engineering_qa,
                     warranty_issue_ber,
                     awaiting_engineering_doa,
                     awaiting_engineering_egh,
                     awaiting_engineering_tag,
                     awaiting_engineering_ops,
                     awaiting_engineering_dell,
                     customer_ddp,
                     customer_adm,
                     customer_mbr,
                     customer_nff,
                     customer_nff2,
                     warranty_issue_ctp,
                     reference_order,
                     ro_note/*                                ,CUSTOMER_ID*/
                            ,
                     customer_name,
                     address_line1,
                     address_line2,
                     address_line3,
                     city/*                                ,STATE*/
                         ,
                     postal_code,
                     customer_country/*                                ,ISO_COUNTRY_CODE*/
                                     ,
                     phone_no,
                     original_customer,
                     internal_notes,
                     type_of_contact,
                     nff_spec_acces,
                     wi_disposition,
                     unit_bcn--                                ,SERIAL_NO
                             ,
                     part_no,
                     part_desc,
                     hold_status--                                ,REASON_FOR_HOLD
                                ,
                     storage_hold_code,
                     storage_hold_code_desc,
                     current_workcenter,
                     destination_workcenter,
                     last_update,
                     workorder_id,
                     wo_created_timestamp,
                     client_reference_no2,
                     bin,
                     product_class,
                     put_on_hold_date,
                     released_from_hold_date,
                     invtorynotes,
                     date_ro_released,
                     activity_creator_group,
                     additional_information,
                     wi_dysp,
                     wi_other_inf,
                     wi_fusion,
                     fusion_created_date,
                     service_event,
                     service_status,
                     itemid,
                     paid_psa,
                     action_code,
                     bcn_call,
                     what_parts_issued,
                     what_parts_removed,
                     ro_update,
                     "Retailer",
                     "ENTITLEMENT",
                     "IB_AWB_1",
                     "IB_AWB_2",
                     "IB_AWB_3",
                     "IB_AWB_4",
                     "IB_AWB_5",
                     "OB_AWB_1",
                     "OB_AWB_2",
                     inbound_service,
                     incident_id,
                     nff_def_freq,
                     dpd_empty_box_awb,
                     second_inbound_awb
                FROM (  SELECT /*+ leading(ro)  index(pc(class_id)) use_nl(ro, pc,ros,btt, calltp_ff) */
                               itl.item_serial_no
                                   AS "Service Tag Received",
                               pc.class_name
                                   AS "Technology",
                               ro.client_reference_no1
                                   AS "DPS Number",
                               btt.business_trx_type_name
                                   AS "BTT Name",
                               gl.location_name
                                   AS "Location",
                               /*report_net.get_flex_field ('Reference Order',
                                                          'CALL Type',
                                                          ro.client_id,
                                                          ro.contract_id,
                                                          NULL,
                                                          rol.part_id,
                                                          NULL,
                                                          ro.reference_order_id,
                                                          rol.reference_order_line_id,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          NULL)*/
                               calltp_ffv.flex_field_value
                                   "CALL Type",
                               cc.flex_field_value
                                   AS "Country",
                               rolsn.serial_no
                                   "Service Tag",
                               /*report_net.get_flex_field ('Reference Order',
                                                          'Service TAG Desc',
                                                          ro.client_id,
                                                          ro.contract_id,
                                                          NULL,
                                                          rol.part_id,
                                                          NULL,
                                                          ro.reference_order_id,
                                                          rol.reference_order_line_id,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          NULL)*/
                               --svtag_ffv.flex_field_value
                               p.part_no
                                   "Model Number",
                               report_net.local_time (ro.location_id,
                                                      ro.created_timestamp)
                                   AS "Call Create Date",
                               report_net.local_time (ro.location_id,
                                                      rlsn.created_timestamp)
                                   "Unit Arrival to Depot Date",
                               (SELECT MAX (
                                           report_net.local_time (
                                               ro.location_id,
                                               ools.created_timestamp))
                                 FROM sl.oo_line_shipment ools
                                WHERE     ools.item_id =
                                          utility1.wizq_get_other_item_id (
                                              itl.item_id,
                                              -1,
                                              'R')
                                      AND ools.inactive_ind = 0)
                                   "prev_shp_timestamp",
                               ros.order_status_name
                                   AS "Order Status",
                               (SELECT itl_m.tracking_number
                                 FROM sl.item_transaction_log itl_m
                                WHERE     itl_m.item_id = itl.item_id
                                      AND itl_m.order_item_oper_id = 13 /*Manifest*/
                                      AND itl_m.order_process_type_code =
                                          'ORET' /*PN20171106 get only tracking from ORET*/
                                      AND NOT EXISTS
                                              (SELECT *
                                                 FROM sl.item_transaction_log
                                                      itl_un
                                                WHERE     itl_un.item_serial_no =
                                                          itl_m.item_serial_no
                                                      AND itl_un.order_item_oper_id =
                                                          81
                                                      AND itl_un.shipment_id =
                                                          itl_m.shipment_id /*Unmanifest*/
                                                      AND itl_un.timestamp >
                                                          itl_m.timestamp))
                                   AS "Delivery TR",
                               (SELECT MAX (itl_m.tracking_number)
                                 FROM sl.reference_order ro2
                                      JOIN sl.item_transaction_log itl_m
                                          --WHERE     itl_m.item_id = itl.item_id
                                          ON ro2.reference_order_id =
                                             itl_m.reference_order_id
                                WHERE     ro2.client_reference_no1 =
                                          ro.client_reference_no1
                                      AND itl_m.order_item_oper_id = 13 /*Manifest*/
                                      AND itl_m.order_process_type_code =
                                          'OSTK'
                                      --                                            IN
                                      --                                            (select
                                      --                                            ro.client_reference_no1
                                      --                                            from sl.reference_order ro
                                      --                                            where
                                      --                                            ro.reference_order_id =  '3410917822')
                                      AND ro2.business_trx_type_id = 409 /*EMPTY BOX*/
                                      AND ROWNUM = 1
                                      AND NOT EXISTS
                                              (SELECT *
                                                 FROM sl.item_transaction_log
                                                      itl_un
                                                WHERE     itl_un.item_serial_no =
                                                          itl_m.item_serial_no
                                                      AND itl_un.order_item_oper_id =
                                                          81
                                                      AND itl_un.shipment_id =
                                                          itl_m.shipment_id /*Unmanifest*/
                                                      AND itl_un.timestamp >
                                                          itl_m.timestamp))
                                   AS eb_tr,                    /*MG20221027*/
                               (SELECT --MAX(REXFERENCE_ORDER_ID)
                                       --ITL_M.TRACKING_NUMBER
                                       sb.return_airbill
                                 FROM sl.reference_order ro2
                                      JOIN sl.item_transaction_log itl_m
                                      JOIN sl.shipment_box sb /*for EMBTY_BOX here return_airbill*/
                                          ON sb.shipment_box_id =
                                             itl_m.shipment_box_id
                                          ON ro2.reference_order_id =
                                             itl_m.reference_order_id
                                WHERE     ro2.client_reference_no1 =
                                          ro.client_reference_no1
                                      AND itl_m.order_item_oper_id = 13 /*Manifest*/
                                      AND itl_m.order_process_type_code =
                                          'OSTK'
                                      AND ro2.business_trx_type_id = 409 /*EMPTY BOX*/
                                      AND ROWNUM = 1
                                      AND NOT EXISTS
                                              (SELECT *
                                                 FROM sl.item_transaction_log
                                                      itl_un
                                                WHERE     itl_un.item_serial_no =
                                                          itl_m.item_serial_no
                                                      AND itl_un.order_item_oper_id =
                                                          81
                                                      AND itl_un.shipment_id =
                                                          itl_m.shipment_id /*Unmanifest*/
                                                      AND itl_un.timestamp >
                                                          itl_m.timestamp))
                                   AS eb_rtr,                  /*MG20221027 */
                               (SELECT MIN (
                                           report_net.local_time (
                                               itl.location_id,
                                               itl_h.timestamp))
                                 FROM sl.item_transaction_log itl_h
                                WHERE     itl_h.location_id = ro.location_id
                                      AND itl_h.item_id = itl.item_id
                                      AND itl_h.order_item_oper_id = 6
                                      /*and regexp_like(to_char(itl_h.storage_hold_code_id), hold_code_regexp_mask))*/
                                      AND itl_h.storage_hold_code_id = 22)
                                   AS "Part Request Date",
                               (SELECT MAX (
                                           report_net.local_time (
                                               itl.location_id,
                                               itl_e.timestamp))
                                 FROM sl.item_transaction_log itl_e
                                WHERE     itl_e.location_id = ro.location_id
                                      AND itl_e.item_id = itl.item_id
                                      AND itl_e.order_item_oper_id = 10)
                                   AS "ERWC Date",
                               CASE
                                   WHEN isl.on_hold_ind = 1
                                   THEN
                                       CASE
                                           WHEN i.storage_hold_code_desc = 'PS'
                                           THEN
                                               'Discrepant Receipt'
                                           WHEN i.storage_hold_code_desc =
                                                'NFF'
                                           THEN
                                               'No Fault Found'
                                           WHEN i.storage_hold_code_desc =
                                                'ADM'
                                           THEN
                                               'More Information'
                                           /*when i.storage_hold_code_desc = 'CTP' then 'Warranty Issue'*/
                                           /*when i.storage_hold_code_desc = 'EGH' then 'Awaiting Engineering'*/
                                           WHEN     st.storage_hold_code =
                                                    'Awaiting Part'
                                                AND exc.flex_field_value =
                                                    'PNA - Part Not Available'
                                           THEN
                                               'Part Backlog'
                                           WHEN st.storage_hold_code =
                                                'Awaiting Part'
                                           THEN
                                               'Waiting Parts'
                                           ELSE
                                               NULL
                                       END
                               END
                                   AS "hold status",
                               CASE
                                   WHEN (SELECT COUNT (*)
                                          FROM sl.item_transaction_log itl_d
                                               JOIN sl.workcenter w
                                                   ON w.workcenter_id =
                                                      itl_d.workcenter_id
                                         WHERE     itl_d.item_id = itl.item_id
                                               AND itl_d.order_item_oper_id IN
                                                       (7)) >
                                        0
                                   THEN
                                       'Released from hold'
                                   ELSE
                                       NULL
                               END
                                   AS "Released_from_hold",
                               CASE
                                   WHEN (SELECT COUNT (*)
                                          FROM sl.item_transaction_log itl_d
                                               JOIN sl.workcenter w
                                                   ON w.workcenter_id =
                                                      itl_d.workcenter_id
                                         WHERE     itl_d.item_id = itl.item_id
                                               AND itl_d.order_item_oper_id IN
                                                       (2)
                                               AND w.workcenter_name =
                                                   'DELL_CAR_DEBUG') >
                                        0
                                   THEN
                                       'Debug_time_out'
                                   ELSE
                                       NULL
                               END
                                   AS "Debug_time_out",         /*MG20150326*/
                               CASE
                                   WHEN (SELECT COUNT (*)
                                          FROM sl.item_transaction_log itl_d
                                               JOIN sl.workcenter w
                                                   ON w.workcenter_id =
                                                      itl_d.workcenter_id
                                         WHERE     itl_d.item_id = itl.item_id
                                               AND itl_d.order_item_oper_id IN
                                                       (1)) >
                                        0
                                   THEN
                                       'Diagnosis'
                                   ELSE
                                       NULL
                               END
                                   AS "Diagnosis",
                               CASE
                                   WHEN exc.flex_field_value =
                                        'CNL - Cancelled Call'
                                   THEN
                                       'Cancel'
                                   WHEN exc.flex_field_value =
                                        'TLP - Logistics Carrier Issue'
                                   THEN
                                       'Logistics Delay'
                                   WHEN (   exc.flex_field_value =
                                            'CNA - Customer Not Available'
                                         OR exc.flex_field_value =
                                            'CAD - Customer Arranged Date')
                                   THEN
                                       'Customer Delay'
                                   ELSE
                                       NULL
                               END
                                   AS "Fusion"    /*   "Diagnosis","Repair",*/
                                              ,
                               CASE
                                   WHEN     btt.business_trx_type_name = 'CR'
                                        AND report_net.get_flex_field (
                                                'Reference Order',
                                                'Inbound Service',
                                                ro.client_id,
                                                ro.contract_id,
                                                NULL,
                                                rol.part_id,
                                                NULL,
                                                ro.reference_order_id,
                                                rol.reference_order_line_id,
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL) = 'SO:MANIFEST'
                                   THEN
                                       (SELECT --MAX(REXFERENCE_ORDER_ID)
                                               --ITL_M.TRACKING_NUMBER
                                               sb.return_airbill
                                         FROM sl.reference_order ro2
                                              JOIN
                                              sl.item_transaction_log itl_m
                                              JOIN sl.shipment_box sb /*for EMBTY_BOX here return_airbill*/
                                                  ON sb.shipment_box_id =
                                                     itl_m.shipment_box_id
                                                  ON ro2.reference_order_id =
                                                     itl_m.reference_order_id
                                        WHERE     ro2.client_reference_no1 =
                                                  ro.client_reference_no1
                                              AND itl_m.order_item_oper_id = 13 /*Manifest*/
                                              AND itl_m.order_process_type_code =
                                                  'OSTK'
                                              AND ro2.business_trx_type_id =
                                                  409            /*EMPTY BOX*/
                                              AND ROWNUM = 1
                                              AND NOT EXISTS
                                                      (SELECT *
                                                         FROM sl.item_transaction_log
                                                              itl_un
                                                        WHERE     itl_un.item_serial_no =
                                                                  itl_m.item_serial_no
                                                              AND itl_un.order_item_oper_id =
                                                                  81
                                                              AND itl_un.shipment_id =
                                                                  itl_m.shipment_id /*Unmanifest*/
                                                              AND itl_un.timestamp >
                                                                  itl_m.timestamp))
                                   WHEN btt.business_trx_type_name = 'CR'
                                   THEN
                                       iawb.flex_field_value
                                   WHEN btt.business_trx_type_name = 'AX'
                                   THEN
                                       sb.return_airbill
                                   ELSE
                                       NULL
                               END
                                   AS "Pick up TR",
                               CASE
                                   WHEN rol.line_status_id IN ('3', '4') /*canceled, comlplete*/
                                   THEN
                                       NVL (                    /*MG20150426*/
                                           /*report_net.local_time (ro.location_id, OO_ORET.CREATED_TIMESTAMP)*/
                                            (SELECT MAX (
                                                        report_net.local_time (
                                                            ro.location_id,
                                                            ools_oret.created_timestamp))
                                             FROM sl.outbound_order oo_oret
                                                  JOIN
                                                  sl.outbound_order_line
                                                  ool_oret
                                                      ON     ool_oret.outbound_order_id =
                                                             oo_oret.outbound_order_id
                                                         AND ool_oret.reference_order_id =
                                                             oo_oret.reference_order_id
                                                  JOIN
                                                  sl.oo_line_shipment ools_oret
                                                      ON     ools_oret.outbound_order_id =
                                                             ool_oret.outbound_order_id
                                                         AND ools_oret.outbound_order_line_id =
                                                             ool_oret.outbound_order_line_id
                                                         AND ools_oret.inactive_ind =
                                                             0
                                            WHERE     oo_oret.reference_order_id =
                                                      ro.reference_order_id
                                                  AND oo_oret.order_process_type_code =
                                                      'ORET'),
                                           report_net.local_time (
                                               ro.location_id,
                                               ro.updated_timestamp))
                                   ELSE
                                       NULL
                               END
                                   AS "Ship and Closed Date",
                               (SELECT report_net.stragg (p.part_no)
                                 FROM sl.defect_code_value dcv
                                      JOIN sl.defect_code dc
                                          ON     dc.id = dcv.defect_code_id
                                             AND dc.has_child = 0
                                      JOIN sl.action_code_value acv
                                          ON     acv.item_id = acv.item_id
                                             AND acv.defect_code_value_id =
                                                 dcv.id
                                      JOIN sl.action_code ac
                                          ON ac.id = acv.action_id
                                      JOIN sl.component_codes cc
                                          ON     cc.isadded = 0
                                             AND cc.ref_itemid IS NULL
                                             AND cc.item_id = acv.item_id
                                             AND cc.action_code_id = acv.id
                                      JOIN sl.part p ON p.part_no = cc.part_no
                                      JOIN sl.fa_flex_field_value ffv_warranty
                                          ON     ffv_warranty.item_id =
                                                 cc.item_id
                                             AND ffv_warranty.code_id = cc.id
                                             AND ffv_warranty.code_type = 5
                                             AND ffv_warranty.fa_ff_id IN
                                                     (SELECT ff.fa_ff_id
                                                       FROM sl.fa_flex_field ff
                                                      WHERE     ff.fa_code_type =
                                                                ffv_warranty.code_type
                                                            AND ff.fa_ff_name =
                                                                'Warranty')
                                      LEFT JOIN
                                      sl.fa_flex_field_value
                                      ffv_warranty_approved
                                          ON     ffv_warranty_approved.item_id =
                                                 cc.item_id
                                             AND ffv_warranty_approved.code_id =
                                                 cc.id
                                             AND ffv_warranty_approved.code_type =
                                                 5
                                             AND ffv_warranty_approved.fa_ff_id IN
                                                     (SELECT ff.fa_ff_id
                                                       FROM sl.fa_flex_field ff
                                                      WHERE     ff.fa_code_type =
                                                                ffv_warranty_approved.code_type
                                                            AND ff.fa_ff_name =
                                                                'Warranty Approved')
                                WHERE     dcv.item_id = itl.item_id
                                      /*PN20171106 replaced subselect with itl.item_id*/
                                      AND (   ffv_warranty.fa_ff_value = 'IW'
                                           OR (    ffv_warranty.fa_ff_value =
                                                   'OOW'
                                               AND ffv_warranty_approved.fa_ff_value =
                                                   'YES')))
                                   "Ordered parts",
                               (SELECT report_net.stragg (p.part_no)
                                 FROM sl.defect_code_value dcv
                                      JOIN sl.defect_code dc
                                          ON     dc.id = dcv.defect_code_id
                                             AND dc.has_child = 0
                                      JOIN sl.action_code_value acv
                                          ON     acv.item_id = acv.item_id
                                             AND acv.defect_code_value_id =
                                                 dcv.id
                                      JOIN sl.action_code ac
                                          ON ac.id = acv.action_id
                                      JOIN sl.component_codes cc
                                          ON     cc.isadded = 1
                                             AND cc.ref_itemid IS NOT NULL
                                             AND cc.item_id = acv.item_id
                                             AND cc.action_code_id = acv.id
                                      JOIN sl.part p ON p.part_id = cc.part_id
                                WHERE dcv.item_id = itl.item_id)
                                   "Parts used",
                               ro.created_by
                                   "Technican ID",
                               (SELECT first_exception_code
                                 FROM (SELECT dps_number,
                                              MIN (dcec.exception_code)
                                              KEEP (DENSE_RANK FIRST
                                                    ORDER BY
                                                        dcec.imported_timestamp)
                                              OVER (
                                                  PARTITION BY dcec.dps_number)    first_exception_code
                                         FROM b2b.dellta_ecode_log dcec)
                                WHERE     dps_number = ro.client_reference_no1
                                      AND ROWNUM = 1)
                                   "First Exception code",
                               (SELECT last_exception_code
                                 FROM (SELECT dps,
                                              MIN (dcec.exception_code)
                                              KEEP (DENSE_RANK LAST
                                                    ORDER BY
                                                        dcec.imported_timestamp)
                                              OVER (PARTITION BY dcec.dps)    last_exception_code
                                         FROM b2b.dell_car_exception_code dcec)
                                WHERE     dps = ro.client_reference_no1
                                      AND ROWNUM = 1)
                                   "Last Exception code_old",
                               (SELECT last_exception_code
                                 FROM (SELECT dps_number,
                                              MIN (dcec.exception_code)
                                              KEEP (DENSE_RANK LAST
                                                    ORDER BY
                                                        dcec.imported_timestamp)
                                              OVER (
                                                  PARTITION BY dcec.dps_number)    last_exception_code
                                         FROM b2b.dellta_ecode_log dcec)
                                WHERE     dps_number = ro.client_reference_no1
                                      AND ROWNUM = 1)
                                   "Last Exception code",       /*MG20170720*/
                               exc.flex_field_value
                                   AS "Current Exception code"/* source REPORT NAME: [RR][RT][GEO-CL-CT-DT][DELL][CAR] Dell Car Hold days quantity */
                                                              ,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Awaiting Part',
                                   '',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   awaiting_part--SR-18999 Rafal Kozlowski
                                                ,
                               (SELECT ROUND (SUM (report_net.calc_working_days_by_client (
                                                       report_net.local_time (
                                                           ro.location_id,
                                                           hold_time),
                                                       NVL (
                                                           report_net.local_time (
                                                               ro.location_id,
                                                               release_time),
                                                           SYSDATE),
                                                       cc.flex_field_value,
                                                       'DELL')),
                                              2)
                                 FROM (  SELECT itlh.order_item_oper_id
                                                    AS hold_oper_id,
                                                (LEAD (itlh.order_item_oper_id)
                                                     OVER (
                                                         PARTITION BY itlh.item_id
                                                         ORDER BY
                                                             itlh.timestamp,
                                                             itlh.order_item_oper_id))
                                                    release_oper_id,
                                                itlh.timestamp
                                                    hold_time,
                                                (LEAD (itlh.timestamp)
                                                     OVER (
                                                         PARTITION BY itlh.item_id
                                                         ORDER BY
                                                             itlh.timestamp,
                                                             itlh.order_item_oper_id))
                                                    release_time
                                           FROM sl.item_transaction_log itlh
                                                JOIN sl.storage_hold_code shc
                                                    ON itlh.storage_hold_code_id =
                                                       shc.storage_hold_code_id
                                          WHERE     itlh.item_id = itl.item_id
                                                AND itlh.order_item_oper_id IN
                                                        (6, 7)
                                                AND UPPER (shc.storage_hold_code) =
                                                    'AWAITING PART'
                                                AND UPPER (
                                                        itlh.storage_hold_code_desc) LIKE
                                                        'SWAP'
                                       ORDER BY itlh.timestamp) t1
                                WHERE t1.hold_oper_id = 6)
                                   awaiting_part_swap-- SR-18999 Rafal Kozlowski
                                                     ,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Awaiting Engineering',
                                   'QA',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   awaiting_engineering_qa,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Warranty Issue',
                                   'BER',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   warranty_issue_ber,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Awaiting Engineering',
                                   'DOA',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   awaiting_engineering_doa,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Awaiting Engineering',
                                   'EGH',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   awaiting_engineering_egh,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Awaiting Engineering',
                                   'TAG',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   awaiting_engineering_tag,
                               --SR-18999 Rafal Kozlowski -->
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Awaiting Engineering',
                                   'OPS',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   awaiting_engineering_ops,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Awaiting Engineering',
                                   'DELL',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   awaiting_engineering_dell,
                               -- SR-18999 Rafal Kozlowski
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Customer',
                                   'DDP',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   customer_ddp,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Customer',
                                   'ADM',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   customer_adm,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Customer',
                                   'MBR',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   customer_mbr,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Customer',
                                   'NFF',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   customer_nff,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Customer',
                                   'NFF2',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   customer_nff2,
                               report_net.get_dgi_hold_time_by_shc_shcd (
                                   itl.item_id,
                                   'Warranty Issue',
                                   'CTP',
                                   ro.location_id,
                                   cc.flex_field_value,
                                   'DELL')
                                   warranty_issue_ctp/*RO with Address Details */
                                                     ,
                               ro.reference_order_id
                                   AS reference_order,
                               ro.note
                                   AS ro_note/*                                ,tp.trading_partner_name as CUSTOMER_ID*/
                                             ,
                               ct.contact_name
                                   AS customer_name,
                               ad.address_line1,
                               ad.address_line2,
                               ad.address_line3,
                               ad.city/*                                ,AD.STATE_PROVINCE as STATE*/
                                      ,
                               ad.postal_code,
                               cc.country_name
                                   AS customer_country/*                                ,cc.iso_country_code*/
                                                      ,
                               cp.phone_no,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'original_customer',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS original_customer,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'internal_notes',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS internal_notes,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'type_of_contact',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS type_of_contact,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'NFF spec. acces.',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS nff_spec_acces,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'WI disposition',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS wi_disposition,
                               itl.item_bcn
                                   AS unit_bcn,
                               p.part_no
                                   part_no,
                               p.part_desc,
                               DECODE (isl.on_hold_ind,
                                       0, 'Released',
                                       1, 'On Hold')
                                   AS hold_status/*                                ,decode(isl.on_hold_ind,1,
                                                                                 (select
                                                                                    iicl.outcome_code_id
                                                                                    from sl.item_info_code_log iicl
                                                                                    where iicl.outcome_code_type = 'HLD'
                                                                                    and iicl.item_trx_log_id = (select
                                                                                                                 max (iicl2.item_trx_log_id)
                                                                                                                 from sl.item_info_code_log iicl2
                                                                                                                 where iicl2.outcome_code_type = 'HLD'
                                                                                                                 and iicl2.item_id = i.item_id
                                                                                                                 )
                                                                                 ),null) as REASON_FOR_HOLD */
                                                 ,
                               shc.storage_hold_code
                                   storage_hold_code,
                               i.storage_hold_code_desc
                                   storage_hold_code_desc,
                               NVL (wc.workcenter_name,
                                    report_net.workcenter_name_rank_trx (
                                        i.item_id,
                                        (SELECT MAX (wc_trx_link_id)
                                           FROM sl.workcenter_trx_log
                                          WHERE item_id = i.item_id),
                                        1))
                                   AS current_workcenter,
                               dwc.workcenter_name
                                   AS destination_workcenter,
                               report_net.local_time (1444,
                                                      isl.updated_timestamp)
                                   AS last_update,
                               wo.workorder_id,
                               wo.created_timestamp
                                   AS wo_created_timestamp,
                               ro.client_reference_no2,
                               b.bin_name
                                   AS bin,
                               prc.class_name
                                   AS product_class,
                               report_net.local_time (
                                   1444,
                                   (SELECT log1.timestamp
                                     FROM sl.item_transaction_log log1
                                    WHERE     log1.item_trx_log_id =
                                              (SELECT MAX (
                                                          log2.item_trx_log_id)
                                                FROM sl.item_transaction_log
                                                     log2
                                               WHERE     log2.order_item_oper_id =
                                                         6
                                                     AND log2.item_id =
                                                         i.item_id)
                                          AND log1.order_item_oper_id = 6
                                          AND log1.item_id = i.item_id))
                                   put_on_hold_date,
                               report_net.local_time (
                                   1444,
                                   (SELECT ivl.trx_timestamp
                                     FROM sl.inventory_trx_log ivl
                                          LEFT JOIN
                                          sl.inventory_trx_operation ivtop
                                              ON ivl.inventory_trx_oper_id =
                                                 ivtop.inventory_trx_oper_id
                                    WHERE     ivtop.inventory_trx_oper_name IN
                                                  ('Move', 'Requisition Move')
                                          AND ivl.item_id = i.item_id
                                          AND ivl.inventory_trx_log_id =
                                              (SELECT MAX (
                                                          ivl.inventory_trx_log_id)
                                                FROM sl.inventory_trx_log ivl
                                               WHERE     ivtop.inventory_trx_oper_name IN
                                                             ('Move',
                                                              'Requisition Move')
                                                     AND ivl.item_id =
                                                         i.item_id)))
                                   released_from_hold_date,
                               (SELECT REGEXP_REPLACE (itl.note, '[[:cntrl:]]')
                                 FROM sl.inventory_trx_log itl
                                WHERE     itl.item_id = i.item_id
                                      AND itl.note IS NOT NULL
                                      AND itl.trx_timestamp BETWEEN   isl.updated_timestamp
                                                                    - .000125
                                                                AND   isl.updated_timestamp
                                                                    + .000125
                                      AND ROWNUM = 1)
                                   AS invtorynotes,
                               (SELECT (report_net.local_time (
                                            1444,
                                            releasedtimestamp))
                                 FROM (SELECT otl.order_id                        order_id,
                                              MIN (otl.timestamp)
                                              KEEP (DENSE_RANK FIRST
                                                    ORDER BY
                                                        otl.created_timestamp)
                                              OVER (PARTITION BY otl.order_id)    releasedtimestamp
                                         FROM sl.order_transaction_log otl
                                        WHERE otl.status_name_new = 'Released')
                                WHERE     order_id = ro.reference_order_id
                                      AND ROWNUM = 1)
                                   AS date_ro_released,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'Activity Creator Group',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS activity_creator_group,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'additional_information',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS additional_information,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'WI_DYSP',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS wi_dysp,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'WI_OTHER_INF',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS wi_other_inf,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'WI_FUSION',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS wi_fusion,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'FUSION_CREATED_DATE',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS fusion_created_date,
                               SUBSTR (report_net.get_flex_field (
                                           'Reference Order',
                                           'Service Event',
                                           ro.client_id,
                                           ro.contract_id,
                                           NULL,
                                           rol.part_id,
                                           NULL,
                                           ro.reference_order_id,
                                           rol.reference_order_line_id,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL),
                                       0,
                                       30) /*ograniczenie do 30 znakï¿½w - error przy 32 znakach */
                                   AS service_event,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'Service Status',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS service_status,
                               i.item_id
                                   AS itemid,
                               CASE
                                   WHEN EXISTS
                                            (SELECT 1
                                               FROM sl.item_transaction_log
                                                    itl_issu
                                                    INNER JOIN sl.part p_issu
                                                        ON p_issu.part_no =
                                                           itl_issu.issued_removed_partno
                                                    INNER JOIN
                                                    sl.product_subclass p_sub
                                                        ON p_sub.subclass_id =
                                                           p_issu.product_subclass_id
                                              WHERE     i.item_id =
                                                        itl_issu.item_id
                                                    AND itl_issu.order_item_oper_id =
                                                        4
                                                    AND p_sub.subclass_name =
                                                        'MAIN BOARD')
                                   THEN
                                       'NON-SUR'
                                   WHEN EXISTS
                                            (SELECT 1
                                               FROM sl.item_transaction_log
                                                    itlwc
                                                    INNER JOIN
                                                    sl.workcenter_trx_log wtl
                                                        ON wtl.wc_trx_link_id =
                                                           itlwc.wc_trx_link_id
                                                    INNER JOIN
                                                    (  SELECT MAX (
                                                                  wctl2.wc_trx_link_id)    wc_trx_link_id_last
                                                         FROM sl.workcenter_trx_log
                                                              wctl2
                                                              INNER JOIN
                                                              sl.workcenter wc2
                                                                  ON wc2.workcenter_id =
                                                                     wctl2.workcenter_id
                                                        WHERE     wctl2.item_id =
                                                                  i.item_id
                                                              AND wc2.workcenter_name =
                                                                  'DELL_CAR_SUR'
                                                     GROUP BY wctl2.item_id)
                                                    wtl1
                                                        ON wtl1.wc_trx_link_id_last =
                                                           itlwc.wc_trx_link_id
                                              WHERE     itlwc.order_item_oper_id =
                                                        2
                                                    AND wtl.result_code_id IN
                                                            ('PASS_DEB',
                                                             'PASS_PA'))
                                   THEN
                                       'SUR'
                                   ELSE
                                       NULL
                               END
                                   AS paid_psa,
                               custom1.get_all_action_code (i.item_id)
                                   AS action_code,
                               report_net.get_flex_field (
                                   'Workcenter',
                                   'iVy Fault',
                                   itl.client_id,
                                   ro.contract_id,
                                   itl.item_id,
                                   NULL,
                                   NULL,
                                   rol.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   i.owner_id,
                                   i.condition_id,
                                   i.location_id)
                                   AS bcn_call,
                               (SELECT report_net.stragg (p.part_no)
                                 FROM sl.defect_code_value dcv
                                      JOIN sl.defect_code dc
                                          ON     dc.id = dcv.defect_code_id
                                             AND dc.has_child = 0
                                      LEFT JOIN sl.defect_code dcp
                                          ON dcp.id = dc.parent_id
                                      LEFT JOIN sl.action_code_value acv
                                          ON     acv.defect_code_value_id =
                                                 dcv.id
                                             AND dcv.item_id = acv.item_id
                                      LEFT JOIN sl.action_code ac
                                          ON ac.id = acv.action_id
                                      INNER JOIN sl.component_codes cc
                                          ON     cc.action_code_id = acv.id
                                             AND cc.isadded = 1
                                      LEFT JOIN sl.part p
                                          ON p.part_id = cc.part_id
                                WHERE dcv.item_id = itl.item_id)
                                   AS what_parts_issued,
                               (SELECT LISTAGG (itl_rem.issued_removed_partno,
                                                ', ')
                                       WITHIN GROUP (ORDER BY itl_rem.timestamp)
                                 FROM sl.item_transaction_log itl_rem
                                WHERE     itl_rem.location_id = ro.location_id
                                      AND itl_rem.client_id = ro.client_id
                                      AND itl_rem.order_item_oper_id IN (8)
                                      AND itl_rem.item_id = i.item_id)
                                   AS what_parts_removed,
                               ro.updated_timestamp
                                   AS ro_update,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'Retailer',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS "Retailer",
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'ENTITLEMENT',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS "ENTITLEMENT"--                                ,CASE
                                                   --                                   WHEN btt.business_trx_type_name = 'CR'
                                                   --                                   THEN
                                                   --                                      iawb.flex_field_value
                                                   --                                   WHEN btt.business_trx_type_name = 'AX'
                                                   --                                   THEN
                                                   --                                      sb.return_airbill
                                                   --                                   ELSE
                                                   --                                      NULL
                                                   --                                END
                                                   --                                   AS "Pick up TR"
                                                   ,
                               DECODE (btt.business_trx_type_name,
                                       'CR', iawb.flex_field_value,
                                       'AX', NULL)
                                   "IB_AWB_1"        /*to samo co Pick up TR*/
                                             ,
                               (SELECT report_net.stragg (
                                           CASE
                                               WHEN LENGTH (logvw.new_value) <
                                                    20
                                               THEN
                                                   logvw.new_value
                                               ELSE
                                                   NULL
                                           END)
                                 FROM custom1.logchange_vw logvw
                                WHERE     logvw.table_nkey1 =
                                          ro.reference_order_id
                                      AND logvw.lookup_field_display =
                                          'Inbound AWB' /*iawb.flex_field_value --MG20220111*/
                                      AND logvw.new_value <>
                                          iawb.flex_field_value)
                                   AS "IB_AWB_2",
                               report_net.get_flex_field ('Receiving SN',
                                                          'AWB Received',
                                                          ro.client_id,
                                                          ro.contract_id,
                                                          itl.item_id,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          NULL)
                                   AS "IB_AWB_3",
                               DECODE (
                                   oo.order_process_type_code,
                                   'OSTK', DECODE (btt.business_trx_type_name,
                                                   'CR', NULL,
                                                   'AX', sb.return_airbill,
                                                   NULL),
                                   NULL)
                                   "IB_AWB_4",
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'Inbound AWB1',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS "IB_AWB_5",
                               DECODE (
                                   oo.order_process_type_code,
                                   'OSTK', DECODE (btt.business_trx_type_name,
                                                   'CR', NULL,
                                                   'AX', sb.tracking_number,
                                                   NULL),
                                   NULL)
                                   "OB_AWB_1",
                               DECODE (
                                   oo_oret.order_process_type_code,
                                   'ORET', DECODE (
                                               btt.business_trx_type_name,
                                               'CR', sb_oret.tracking_number,
                                               'AX', sb_oret.tracking_number,
                                               NULL),
                                   NULL)
                                   "OB_AWB_2"                    /*4403 rows*/
                                             ,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'Inbound Service',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS inbound_service,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'Incident ID',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS incident_id,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'NFF def. freq.',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS nff_def_freq,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'DPD EMPTY BOX AWB',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS dpd_empty_box_awb,
                               report_net.get_flex_field (
                                   'Reference Order',
                                   'Second Inbound AWB',
                                   ro.client_id,
                                   ro.contract_id,
                                   NULL,
                                   rol.part_id,
                                   NULL,
                                   ro.reference_order_id,
                                   rol.reference_order_line_id,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL)
                                   AS second_inbound_awb
                          FROM sl.reference_order ro
                               INNER JOIN sl.reference_order_line rol
                                   ON rol.reference_order_id =
                                      ro.reference_order_id
                               INNER JOIN sl.geo_location gl
                                   ON gl.location_id = ro.location_id
                               INNER JOIN sl.order_status ros   /*20150216MG*/
                                   ON ros.order_status_id = ro.order_status_id /* ROL.LINE_STATUS_ID*/
                               INNER JOIN sl.reference_order_line_sn rolsn
                                   ON     rolsn.reference_order_id =
                                          rol.reference_order_id
                                      AND rolsn.reference_order_line_id =
                                          rol.reference_order_line_id
                               INNER JOIN sl.business_trx_type btt
                                   ON btt.business_trx_type_id =
                                      ro.business_trx_type_id
                               LEFT JOIN sl.item_transaction_log itl
                                   ON     itl.reference_order_id =
                                          rol.reference_order_id
                                      AND itl.order_line_id =
                                          rol.reference_order_line_id
                                      AND itl.order_item_oper_id = 11
                               LEFT JOIN sl.item_transaction_log itl_rec_next
                                   ON     itl_rec_next.reference_order_id =
                                          itl.reference_order_id
                                      AND itl_rec_next.order_line_id =
                                          itl.reference_order_line_id
                                      AND itl_rec_next.order_item_oper_id = 11
                                      AND itl_rec_next.timestamp >
                                          itl.timestamp
                               LEFT JOIN sl.item i ON i.item_id = itl.item_id
                               LEFT JOIN sl.item_status_log isl
                                   ON     itl.item_id = isl.item_id
                                      AND itl.location_id = isl.location_id
                               LEFT JOIN sl.storage_hold_code st
                                   ON st.storage_hold_code_id =
                                      i.storage_hold_code_id
                               LEFT JOIN sl.receipt_line_sn rlsn
                                   ON     rlsn.receipt_id = itl.receipt_id
                                      AND rlsn.inactive_ind = 0
                               LEFT JOIN sl.receipt_line_sn rlsn_next
                                   ON     rlsn_next.receipt_id =
                                          itl_rec_next.receipt_id
                                      AND rlsn_next.inactive_ind = 0
                                      AND rlsn_next.inactive_ind = 0
                               LEFT JOIN sl.workorder wo
                                   ON     wo.reference_order_id =
                                          ro.reference_order_id
                                      AND wo.order_status_id = 2   /*in WIP */
                               LEFT JOIN sl.workorder_line wol
                                   ON wo.workorder_id = wol.workorder_id
                               LEFT JOIN sl.workorder_line_bcn wolbcn
                                   ON     wol.workorder_id =
                                          wolbcn.workorder_id
                                      AND wol.workorder_line_id =
                                          wolbcn.workorder_line_id
                               LEFT JOIN sl.part p ON p.part_id = rol.part_id
                               JOIN sl.part_class pc
                                   ON     pc.class_id = p.class_id
                                      AND pc.class_name IN
                                              ('LAPTOP', 'DESKTOP', 'TABLET')
                               LEFT JOIN sl.reference_order_ext calltp_ff
                                   ON     calltp_ff.client_id = ro.client_id
                                      AND calltp_ff.contract_id =
                                          ro.contract_id
                                      AND calltp_ff.flex_field_name =
                                          'CALL Type'
                                      AND calltp_ff.business_trx_type_id =
                                          ro.business_trx_type_id
                               LEFT OUTER JOIN sl.ro_flex_field calltp_ffv
                                   ON     calltp_ff.ro_ext_id =
                                          calltp_ffv.ro_ext_id
                                      AND calltp_ffv.reference_order_id =
                                          ro.reference_order_id
                               --                                 LEFT JOIN sl.reference_order_ext svtag_ff
                               --                                    ON     svtag_ff.client_id = ro.client_id
                               --                                       AND svtag_ff.contract_id = ro.contract_id
                               --                                       AND svtag_ff.flex_field_name = 'CALL Type'
                               --                                       AND svtag_ff.business_trx_type_id =
                               --                                              ro.business_trx_type_id
                               --                                 LEFT OUTER JOIN sl.ro_flex_field svtag_ffv
                               --                                    ON     svtag_ff.ro_ext_id =
                               --                                              svtag_ffv.ro_ext_id
                               --                                       AND svtag_ffv.reference_order_id =
                               --                                              ro.reference_order_id
                               LEFT JOIN sl.reference_order_ext roe
                                   ON     roe.client_id = ro.client_id
                                      AND roe.contract_id = ro.contract_id
                                      AND roe.flex_field_name =
                                          'original_country'
                                      AND roe.business_trx_type_id =
                                          ro.business_trx_type_id
                               LEFT JOIN sl.ro_flex_field cc
                                   ON     cc.ro_ext_id = roe.ro_ext_id
                                      AND cc.reference_order_id =
                                          ro.reference_order_id
                               LEFT JOIN sl.reference_order_ext ffec
                                   ON     ffec.client_id = ro.client_id
                                      AND ffec.contract_id = ro.contract_id
                                      AND ffec.flex_field_name =
                                          'Exception Code'
                                      AND ffec.business_trx_type_id =
                                          ro.business_trx_type_id
                               LEFT JOIN sl.ro_flex_field exc
                                   ON     exc.ro_ext_id = ffec.ro_ext_id
                                      AND exc.reference_order_id =
                                          ro.reference_order_id
                               LEFT JOIN sl.reference_order_ext ffiawb
                                   ON     ffiawb.client_id = ro.client_id
                                      AND ffiawb.contract_id = ro.contract_id
                                      AND ffiawb.flex_field_name =
                                          'Inbound AWB'
                                      AND ffiawb.business_trx_type_id =
                                          ro.business_trx_type_id
                               LEFT JOIN sl.ro_flex_field iawb
                                   ON     iawb.ro_ext_id = ffiawb.ro_ext_id
                                      AND iawb.reference_order_id =
                                          ro.reference_order_id
                               LEFT JOIN sl.outbound_order oo
                                   ON     oo.reference_order_id =
                                          ro.reference_order_id
                                      AND oo.order_process_type_code = 'OSTK'
                               LEFT JOIN sl.outbound_order_line ool
                                   ON     ool.outbound_order_id =
                                          oo.outbound_order_id
                                      AND ool.reference_order_id =
                                          oo.reference_order_id
                               LEFT JOIN sl.oo_line_shipment ools
                                   ON     ools.outbound_order_id =
                                          ool.outbound_order_id
                                      AND ools.outbound_order_line_id =
                                          ool.outbound_order_line_id
                                      AND ools.inactive_ind = 0
                               LEFT JOIN sl.shipment_box sb /*for AX here return_airbill*/
                                   ON sb.shipment_box_id = ools.shipment_box_id
                               /*                                        inner join sl.TRADING_PARTNER tp
                                                                           on RO.TRADING_PARTNER_ID = TP.TRADING_PARTNER_ID*/
                               LEFT JOIN sl.outbound_order oo_oret --MG20210325 adding for"OB_AWB_2" how about duplicates ?
                                   ON     oo_oret.reference_order_id =
                                          ro.reference_order_id
                                      AND oo_oret.order_process_type_code =
                                          'ORET'
                               LEFT JOIN sl.outbound_order_line ool_oret
                                   ON     ool_oret.outbound_order_id =
                                          oo_oret.outbound_order_id
                                      AND ool_oret.reference_order_id =
                                          oo_oret.reference_order_id
                               LEFT JOIN sl.oo_line_shipment ools_oret
                                   ON     ools_oret.outbound_order_id =
                                          ool_oret.outbound_order_id
                                      AND ools_oret.outbound_order_line_id =
                                          ool_oret.outbound_order_line_id
                                      AND ools_oret.inactive_ind = 0
                               LEFT JOIN sl.shipment_box sb_oret
                                   ON sb_oret.shipment_box_id =
                                      ools_oret.shipment_box_id
                               LEFT JOIN sl.ship_to_party stp
                                   ON ro.outbound_ship_to_party_id =
                                      stp.ship_to_party_id
                               LEFT JOIN sl.entity_address ea
                                   ON     stp.ship_to_party_id = ea.entity_id
                                      AND ea.entity_type_id = 4
                               LEFT JOIN sl.address ad
                                   ON ea.address_id = ad.address_id
                               LEFT OUTER JOIN sl.entity_contact ec
                                   ON     stp.ship_to_party_id = ec.entity_id
                                      AND ea.entity_type_id = 4
                                      AND ec.entity_id =
                                          ro.outbound_ship_to_party_id
                               LEFT OUTER JOIN sl.contact ct
                                   ON ec.contact_id = ct.contact_id
                               LEFT JOIN sl.country_code cc
                                   ON ad.country_id = cc.country_id
                               LEFT OUTER JOIN sl.contact_phone cp
                                   ON     cp.contact_id = ec.contact_id
                                      AND cp.phone_type_id = 14
                               LEFT OUTER JOIN sl.storage_hold_code shc
                                   ON shc.storage_hold_code_id =
                                      i.storage_hold_code_id
                               LEFT JOIN sl.workcenter wc
                                   ON wc.workcenter_id =
                                      isl.current_workcenter_id
                               LEFT JOIN sl.workcenter dwc
                                   ON dwc.workcenter_id =
                                      isl.destination_workcenter_id
                               LEFT JOIN sl.bin b ON b.bin_id = i.bin_id
                               LEFT JOIN sl.product_class prc
                                   ON p.product_class_id = prc.class_id
                         WHERE     ro.location_id IN (1444, 1928, 202) /* 202 bez Coventry - INC 93447*/
                               AND ro.client_id IN (17302)
                               AND ro.contract_id IN (10375, 39189) /*MG20240523 trzeba dodac nowy  kontrakt CAR_PS */
                               AND ro.order_status_id IN (1,
                                                          2,
                                                          3,
                                                          4)
                               AND ro.business_trx_type_id IN (2,
                                                               267,
                                                               1,
                                                               345)
                               AND NOT EXISTS
                                       (SELECT NULL
                                          FROM sl.reference_order ro2
                                         WHERE     ro2.client_reference_no1 =
                                                   ro.client_reference_no1
                                               AND ro2.contract_id =
                                                   ro.contract_id /*MG20240624 adding */
                                               AND ro2.business_trx_type_id =
                                                   ro.business_trx_type_id /*MG20240624 adding */
                                               AND ro2.created_timestamp >
                                                   ro.created_timestamp)
                               AND NOT EXISTS
                                       (SELECT NULL               --MG20150526
                                          FROM sl.item_transaction_log itl2
                                         WHERE     itl2.item_id = itl.item_id
                                               AND itl2.receipt_id =
                                                   itl.receipt_id
                                               AND itl2.order_item_oper_id = 12 /*Unreceive Inbound Unit  duplikat country GB*/
                                                                               )
                               AND NOT EXISTS                  /*-MG20170803*/
                                       (SELECT 'x'
                                          FROM sl.item_transaction_log itl_r
                                         WHERE     itl_r.item_id = itl.item_id
                                               AND itl_r.receipt_id =
                                                   rlsn_next.receipt_id
                                               AND itl_r.order_item_oper_id =
                                                   11 /*MG20220107 adding for performance*/
                                                     )
                               AND ro.client_reference_no1 IS NOT NULL /*MG20220706*/
                               AND ro.updated_timestamp >= /*PN20181213 changed from created for better indexing*/
                                   DECODE (
                                       'HR',
                                       'T', report_net.local_time_to_utc (
                                                ro.location_id,
                                                TRUNC (
                                                    report_net.local_time (
                                                        ro.location_id,
                                                        SYSDATE))),
                                       'Y', report_net.local_time_to_utc (
                                                ro.location_id,
                                                TRUNC (
                                                      report_net.local_time (
                                                          ro.location_id,
                                                          SYSDATE)
                                                    - 1)),
                                       'CW', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TRUNC (
                                                     report_net.local_time (
                                                         ro.location_id,
                                                         SYSDATE),
                                                     'IW')),
                                       'PW', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TRUNC (
                                                       report_net.local_time (
                                                           ro.location_id,
                                                           SYSDATE)
                                                     - 7,
                                                     'IW')),
                                       'CM', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TRUNC (
                                                     report_net.local_time (
                                                         ro.location_id,
                                                         SYSDATE),
                                                     'MM')),
                                       'PM', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 ADD_MONTHS (
                                                     TRUNC (
                                                         report_net.local_time (
                                                             ro.location_id,
                                                             SYSDATE),
                                                         'MM'),
                                                     -1)),
                                       'DR', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TO_DATE (
                                                     '2021-01-20 00:00:00.0',
                                                     'YYYY-MM-DD HH24:MI:SS    ')),
                                       'SR', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TO_DATE (
                                                        TO_CHAR (
                                                              report_net.local_time (
                                                                  ro.location_id,
                                                                  SYSDATE)
                                                            + TO_NUMBER ('0'),
                                                            'YYYY-MM-DD')
                                                     || ' '
                                                     || SUBSTR ('00:00:00.000',
                                                                1,
                                                                8),
                                                     'YYYY-MM-DD HH24:MI:SS')),
                                       'HR', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                   TRUNC (
                                                       report_net.local_time (
                                                           ro.location_id,
                                                           SYSDATE),
                                                       'HH')
                                                 - (2500 / 24))--'HR',report_net.local_time_to_utc( ro.location_id  ,trunc(report_net.local_time( ro.location_id  ,sysdate),'HH') - (2000 /24))
                                                               )
                               --           AND RO.updated_timestamp  <= /*PN20181213 changed from created for better indexing*/
                               --           decode('HR',
                               --           'T',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,trunc(REPORT_NET.LOCAL_TIME(ro.location_id,sysdate)+1)),
                               --           'Y',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,trunc(REPORT_NET.LOCAL_TIME(ro.location_id,sysdate))),
                               --           'CW',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,trunc(REPORT_NET.LOCAL_TIME(ro.location_id,sysdate)+1)),
                               --           'PW',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,trunc(REPORT_NET.LOCAL_TIME(ro.location_id,sysdate),'IW')),
                               --           'CM',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,trunc(REPORT_NET.LOCAL_TIME(ro.location_id,sysdate)+1)),
                               --           'PM',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,trunc(REPORT_NET.LOCAL_TIME(ro.location_id,sysdate),'MM')),
                               --           'DR',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id, TO_DATE('2020-12-09 00:00:00.0','YYYY-MM-DD HH24:MI:SS    ')),
                               --           'SR',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,TO_DATE (TO_CHAR (REPORT_NET.LOCAL_TIME(ro.location_id,sysdate) + TO_NUMBER('0') ,'YYYY-MM-DD')|| ' ' || SUBSTR('00:00:00.000',1,8), 'YYYY-MM-DD HH24:MI:SS' )),
                               --           'HR',REPORT_NET.LOCAL_TIME_TO_UTC(ro.location_id,trunc(REPORT_NET.LOCAL_TIME(ro.location_id,sysdate)+1))
                               --           )
                               AND ro.created_timestamp >= /*MG20200421 adding for delete old calls */
                                   DECODE (
                                       'HR',
                                       'T', report_net.local_time_to_utc (
                                                ro.location_id,
                                                TRUNC (
                                                    report_net.local_time (
                                                        ro.location_id,
                                                        SYSDATE))),
                                       'Y', report_net.local_time_to_utc (
                                                ro.location_id,
                                                TRUNC (
                                                      report_net.local_time (
                                                          ro.location_id,
                                                          SYSDATE)
                                                    - 1)),
                                       'CW', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TRUNC (
                                                     report_net.local_time (
                                                         ro.location_id,
                                                         SYSDATE),
                                                     'IW')),
                                       'PW', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TRUNC (
                                                       report_net.local_time (
                                                           ro.location_id,
                                                           SYSDATE)
                                                     - 7,
                                                     'IW')),
                                       'CM', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TRUNC (
                                                     report_net.local_time (
                                                         ro.location_id,
                                                         SYSDATE),
                                                     'MM')),
                                       'PM', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 ADD_MONTHS (
                                                     TRUNC (
                                                         report_net.local_time (
                                                             ro.location_id,
                                                             SYSDATE),
                                                         'MM'),
                                                     -1)),
                                       'DR', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TO_DATE (
                                                     '2021-01-20 00:00:00.0',
                                                     'YYYY-MM-DD HH24:MI:SS    ')),
                                       'SR', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                 TO_DATE (
                                                        TO_CHAR (
                                                              report_net.local_time (
                                                                  ro.location_id,
                                                                  SYSDATE)
                                                            + TO_NUMBER ('0'),
                                                            'YYYY-MM-DD')
                                                     || ' '
                                                     || SUBSTR ('00:00:00.000',
                                                                1,
                                                                8),
                                                     'YYYY-MM-DD HH24:MI:SS')),
                                       'HR', report_net.local_time_to_utc (
                                                 ro.location_id,
                                                   TRUNC (
                                                       report_net.local_time (
                                                           ro.location_id,
                                                           SYSDATE),
                                                       'HH')
                                                 - (2500 / 24)))
                               AND ro.client_reference_no1 NOT IN
                                       ('07443017541'           /*INC-106976*/
                                                     )
                      ORDER BY ro.updated_timestamp DESC))
