#!/system/bin/sh

clear

if [ -d "/data/adb/tricky_store/" ]; then
    echo "/data/adb/tricky_store/目录已存在 (/data/adb/tricky_store/ directory already exists)"
else
    echo "/data/adb/tricky_store/目录不存在,请先安装Tricky Store/TEESimulator/TEESimulator-RS模块"
    echo "(/data/adb/tricky_store/ directory does not exist, please install Tricky Store/TEESimulator/TEESimulator-RS module first)"
    exit 1
fi

echo ""
echo "请选择补丁日期获取模式 (Please select the security patch date acquisition mode):"
echo "1) 补丁日期获取(先用这个) / Get Patch Date (Try this first)"
echo "2) 上面不行的用这个 / Use this if the above workarounds are needed"
echo ""
echo -n "请输入选项 (1 或 2) / Please enter an option (1 or 2): "
read user_choice

patch_line=$(grep "^ro.build.version.security_patch=" /system/build.prop 2>/dev/null)

if [ -n "$patch_line" ]; then
    patch_date_full=${patch_line#*=}
    patch_date_yyyymm=$(echo "$patch_date_full" | cut -d'-' -f1-2 | tr -d '-')
else
    patch_date_full="unknown"
    patch_date_yyyymm="unknown"
fi

output="/data/adb/tricky_store/security_patch.txt"

if [ -f "$output" ]; then
    mv "$output" "${output}.bak"
    echo "已备份原文件为 security_patch.txt.bak (Original file backed up as security_patch.txt.bak)"
fi

case $user_choice in
    1)
        echo "使用模式1: 标准补丁日期 (Using Mode 1: Standard Patch Date)"
        echo "system=$patch_date_yyyymm" > "$output"
        echo "boot=$patch_date_full" >> "$output"
        echo "vendor=$patch_date_full" >> "$output"
        ;;
    2)
        echo "使用模式2: vendor=prop (Using Mode 2: vendor=prop)"
        echo "system=$patch_date_yyyymm" > "$output"
        echo "boot=$patch_date_full" >> "$output"
        echo "vendor=prop" >> "$output"
        ;;
    *)
        echo "无效输入 默认使用模式1 (Invalid input. Defaulting to Mode 1)"
        echo "system=$patch_date_yyyymm" > "$output"
        echo "boot=$patch_date_full" >> "$output"
        echo "vendor=$patch_date_full" >> "$output"
        ;;
esac

echo "已生成 $output ($output generated successfully)"
cat "$output"
