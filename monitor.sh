#!/bin/bash

# ================= [설정 확인 필수] =================
# 목표 블록
TARGET_BLOCK=1910000

# Geth 실행 파일 경로 (자신의 환경에 맞게 수정)
GETH_BIN="./build/bin/geth"

# ★중요★: 아까 실행할 때 --datadir 로 지정한 경로 뒤에 /geth.ipc를 붙여야 합니다.
# 예: --datadir /root/my-fork-data  ==>  /root/my-fork-data/geth.ipc
IPC_PATH="/root/my-fork-data/geth.ipc"
# ====================================================

echo "=================================================="
echo "모니터링 시작: 목표 $TARGET_BLOCK"
echo "IPC 경로 확인: $IPC_PATH"
echo "=================================================="

while true; do
    # 1. IPC 파일이 실제로 존재하는지 먼저 확인
    if [ ! -S "$IPC_PATH" ]; then
        echo "❌ 에러: IPC 파일을 찾을 수 없습니다!"
        echo "   경로: $IPC_PATH"
        echo "   Geth가 실행 중인지, datadir 경로가 맞는지 확인하세요."
        sleep 3
        continue
    fi

    # 2. 현재 블록 높이 조회 (에러 메시지도 변수에 담음)
    CURRENT_BLOCK=$($GETH_BIN attach "$IPC_PATH" --exec "eth.blockNumber" 2>&1)

    # 3. 결과가 숫자인지 확인 (정상 응답)
    if [[ "$CURRENT_BLOCK" =~ ^[0-9]+$ ]]; then
        # 정상 출력: 현재 블록 / 목표 블록 보여주기
        echo "✅ 현재 블록: $CURRENT_BLOCK  /  목표: $TARGET_BLOCK (진행중...)"

        # 목표 도달 시 종료
        if [ "$CURRENT_BLOCK" -ge "$TARGET_BLOCK" ]; then
            echo ""
            echo "🛑 목표 블록 도달함! ($CURRENT_BLOCK)"
            echo "Geth를 종료합니다..."
            pkill -SIGINT -f "geth"
            break
        fi
    else
        # 에러 출력: Geth 연결은 됐는데 엉뚱한 응답이 옴 (또는 연결 에러)
        echo "⚠️  Geth 응답 오류: $CURRENT_BLOCK"
    fi

    # 3초 대기
    sleep 3
done
