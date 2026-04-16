#!/usr/bin/env python3
"""Stitch 스크린 파일명 리네이밍: screen_id → key_name 형식"""

import os
import shutil

MAPPING = {
    # A. 온보딩
    "796da6a0cd1d43ea9e0da24384ed37ab": "A1_splash",
    "ee715182e6d34f5bb515393339a86905": "A2_welcome",
    "416248cd3bdb440193799025a82191db": "A3_pregnancy_input",
    "2d9dfd285a4d452fad460831def8a271": "A4_postnatal_input",
    "49b8d68e18bd4f9b8616d3fc53b1696f": "A5_notification_permission",
    # B. 홈탭
    "cc7c82348e204dcd909fdf4967086be3": "B1_home_pregnant",
    "4dbc2ba441d84a308bed430971c75b17": "B2_home_postnatal",
    "4a7b98b2c3c04c64a5e0737e4330944e": "B3_letter_detail",
    "dac98c148fac4494b9f9a4a6b50677c5": "B4_fetal_video",
    "7241c273d6d94e6bb566f640697c03ad": "B5_letter_collection",
    "5febe3db222841bb9b9a95ce0aad78d7": "B6_serve_return",
    "a92e0941439243a289d9f43cdfa9105b": "B7_4th_trimester",
    "bbe76e4ea0dc434fa9c58b503ac56a44": "B8_dev_tip_detail",
    "55a2d6ad944b4839b0b9cff78ab6b114": "B9_notification_center",
    "69472d0164254b698fb3e86f25b309be": "B10_milestone_celebration",
    # C. 기록탭
    "28b875d00b0c4b1fbd09360dce2a4d97": "C1_record_pregnant",
    "ee3d80da99694b7b80d8a78e0b6947ac": "C2_record_postnatal",
    "3e0cbb49acdf4782aae15b2a8e42ec46": "C3_kick_counter",
    "d1128920997a4a87b029a3e58045e4db": "C4_mood_diary",
    "cd2ba8ab9ec840e99109c7772584f9ae": "C5_photo_diary",
    "bbdad902e0c646eeb1f686f9f3b3a2dd": "C6_weight_tracking",
    "43d82bfee779489b879adeb6c8dee363": "C7_blood_pressure",
    "29c65e24f32c4aa892e967ab602fd807": "C8_symptom_log",
    "3bf43825d5d140b1a6c5449aa0e371a9": "C9_record_history",
    "c712e5fb8e394ea0871d517c4696b9bc": "C10_sleep_tracking",
    "56a144a80067490ca523a5314a4a6b71": "C11_feeding_log",
    "13141ecceebf49bba2719c7c6dc971bb": "C12_diaper_log",
    "1506fde4897243f38ae04328f589ef83": "C13_growth_measurement",
    # D. 성장탭
    "a188429306cf4fa085602dc6fca45b88": "D1_growth_timeline",
    "251349b6d75d4e5ca4a9334744bc3b39": "D2_milestone_detail",
    "09b0451592914f0f96a8e65f426b1d47": "D3_photo_compare",
    "6601081f985f493492045f704593717a": "D4_baby_profile",
    "eac2887ec8684c489208d8f072f28c9c": "D5_weekly_comparison",
    "3881d3a34b7042a4bb9e5106a93dea48": "D6_pattern_sleep",
    "c409772f26f04833ba43c54fef0d24bc": "D7_pattern_feed",
    "bc35e198f4a14e6a82553fcaa5b64db8": "D8_who_growth_chart",
    # E. 우리탭
    "31d7b078ca024a7396b6b092b79763ef": "E1_us_main",
    "a56f3153862e4b88aa4994f725103597": "E2_epds_survey",
    "79d2f22a107d44d5b703c8ccd9cd36c8": "E3_epds_history",
    "a33deaa2c16140aabce1673247c112eb": "E4_epds_results",
    "bc99032cf54045909f6e37c07a5df9fa": "E7_expert_guide",
    "f1b773cda1f742bba0307b2053b575d8": "E8_family_mission",
    "3cd13962b994474cbb0b14e9f77606cb": "E9_family_photo",
    "358a32ab2fa34e4db4c9dccc83ee27de": "E10_community",
    # F. 설정
    "6404ba59959f4dd88586734fcadb9daa": "F1_settings_main",
    "72eb3fc3980044269b31694aeef26424": "F2_profile_edit",
    "eea94ea8874543e298cd678633390010": "F3_app_info",
    "4af8ab696ba3432db8011ca0daf25723": "F4_data_export",
    "b79d91ab737446fa9705e62aa3dccd58": "F5_premium",
    "93dc5b1916e845b19ad038fab3dd8740": "F6_notification_settings",
    # G. 게이미피케이션
    "f99d07fc849f48d6a87bbdc7e71d539a": "G1_badge_collection",
    "bd8e0e233d864b479940e9c2576b5e73": "G2_level_xp",
    "3ab9895c99954deca02c07ddf90face9": "G3_character_evolution",
    "2c27328563d3453b8e5f0fe837d3df85": "G4_weekly_challenge",
    # NEW. 신규 기능
    "899b8f4b3d9f4ccfb1b641f0527f5caf": "NEW1_emotion_checkin",
    "e353e921ae9d4085ad501c0741e7c31f": "NEW2_care_nudge",
    "00357c5a57434fe8ac619e6990c6fcce": "NEW3_gratitude_journal",
    "50d3d0e8e95845f6bbcf196b2c5afc13": "NEW4_concern_alert",
    "7505d5f8830a45c096b80bd79625444a": "NEW5_weekly_fetal_card",
    # ASSET
    "2533b2cdcbe64b64b71fc6cb7cef3f18": "ASSET1_pregnant_illustration",
    "c4a5174758f54dd7ad97be5b51cd25c8": "ASSET2_character_illustration",
}

def rename_files(directory):
    if not os.path.exists(directory):
        print(f"Directory not found: {directory}")
        return

    renamed = 0
    skipped = 0
    for filename in os.listdir(directory):
        if not filename.endswith('.html'):
            continue
        screen_id = filename.replace('.html', '')
        if screen_id in MAPPING:
            new_name = MAPPING[screen_id] + '.html'
            old_path = os.path.join(directory, filename)
            new_path = os.path.join(directory, new_name)
            if not os.path.exists(new_path):
                shutil.move(old_path, new_path)
                print(f"  {filename} -> {new_name}")
                renamed += 1
            else:
                print(f"  SKIP (exists): {new_name}")
                skipped += 1
        else:
            print(f"  UNKNOWN: {filename}")
            skipped += 1

    print(f"\nRenamed: {renamed}, Skipped: {skipped}")

if __name__ == "__main__":
    code_dir = os.path.join(os.path.dirname(__file__), "code")
    print(f"Renaming files in: {code_dir}")
    rename_files(code_dir)
