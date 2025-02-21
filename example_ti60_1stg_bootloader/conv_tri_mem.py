#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
import shutil
import subprocess
import argparse

def main():
    parser = argparse.ArgumentParser(description="Convert binary memory files to hex format.")
    parser.add_argument("path", help="Path to the directory containing imem.bin and dmem.bin")
    parser.add_argument("--boot", action="store_true", help="Use boot memory offsets")
    args = parser.parse_args()
    
    addr_imem = "0xF9000000"
    addr_dmem = "0xF9080000"
    addr_imem_boot = "0xF9007800"
    addr_dmem_boot = "0xF9087800"
    
    addr_imem_offset = addr_imem_boot if args.boot else addr_imem
    addr_dmem_offset = addr_dmem_boot if args.boot else addr_dmem
    
    input_path = args.path
    imem_path = os.path.join(input_path, "imem.bin")
    dmem_path = os.path.join(input_path, "dmem.bin")
    
    # imem.bin と dmem.bin の存在確認
    if not os.path.exists(imem_path) or not os.path.exists(dmem_path):
        print("[ERROR] imem.bin と dmem.bin の両方が見つかりません。")
        print("  - imem.bin の存在: {}".format(os.path.exists(imem_path)))
        print("  - dmem.bin の存在: {}".format(os.path.exists(dmem_path)))
        sys.exit(1)
    
    # ./romdata フォルダが存在しない場合は作成
    romdata_dir = "./romdata"
    os.makedirs(romdata_dir, exist_ok=True)
    
    # ファイルを ./romdata にコピー
    try:
        shutil.copy(imem_path, romdata_dir)
        shutil.copy(dmem_path, romdata_dir)
    except Exception as e:
        print("[ERROR] ファイルのコピーに失敗しました: {}".format(e))
        sys.exit(1)
    
    # bin から hex への変換スクリプト実行
    try:
        print("[INFO] Running trinitaHexGen.py for imem.bin...")
        subprocess.run(["python", os.path.join(romdata_dir, "trinitaHexGen.py"),
                        os.path.join(romdata_dir, "imem.bin"),
                        addr_imem, addr_imem_offset], check=True)
        
        print("[INFO] Running trinitaHexGen.py for dmem.bin...")
        subprocess.run(["python", os.path.join(romdata_dir, "trinitaHexGen.py"),
                        os.path.join(romdata_dir, "dmem.bin"),
                        addr_dmem, addr_dmem_offset], check=True)
    except subprocess.CalledProcessError as e:
        print("[ERROR] trinitaHexGen.py 実行中にエラーが発生しました: {}".format(e))
        sys.exit(1)
    
    print("[INFO] bin から hex への変換が完了しました。")
    sys.exit(0)

if __name__ == "__main__":
    main()
