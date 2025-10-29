const fs = require('fs');

const file = 'src/addon/sport/pages/event/detail.vue';
const content = fs.readFileSync(file, 'utf-8');
const lines = content.split('\n');

console.log('\n====== 关键 view 标签结构 ======\n');

// 只显示关键的 view 标签
const keyLines = [1, 2, 4, 9, 555, 556, 557, 558, 559, 560, 561, 564, 565, 566, 567, 647, 648, 649, 650, 657, 658, 659];

keyLines.forEach(lineNum => {
    if (lineNum <= lines.length) {
        const line = lines[lineNum - 1];
        const trimmed = line.trim();
        const indent = line.match(/^\s*/)[0].length;
        const marker = trimmed.includes('<view') ? '▶' : trimmed.includes('</view>') ? '◀' : ' ';
        console.log(`${lineNum.toString().padStart(4)}: ${' '.repeat(Math.floor(indent/4))}${marker} ${trimmed.substring(0, 80)}`);
    }
});

console.log('\n分析：');
console.log('第2行: container 开始');
console.log('第4行: v-if="loading" 开始 (第6行闭合)');
console.log('第9行: v-else-if="eventInfo" event-detail 开始');
console.log('第558行: 应该是 event-detail 的闭合？');
console.log('第561行: v-else error-container 开始 (第564行闭合)');
console.log('第567行: v-if="eventInfo" diy-edit-section 开始 (第647行闭合)');
console.log('第650行: bottom-actions 开始 (第657行闭合)');
console.log('第658行: 应该是 container 的闭合');

