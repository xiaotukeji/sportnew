const fs = require('fs');

const file = 'src/addon/sport/pages/event/detail.vue';
const content = fs.readFileSync(file, 'utf-8');
const lines = content.split('\n');

let inTemplate = false;
let stack = [];

console.log('\n====== 详细 View 标签追踪 ======\n');

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const lineNum = i + 1;
    
    if (line.includes('<template>')) {
        inTemplate = true;
        continue;
    }
    if (line.includes('</template>')) {
        inTemplate = false;
        break;
    }
    
    if (!inTemplate) continue;
    
    // 移除注释和字符串中的内容
    let processLine = line.replace(/<!--[\s\S]*?-->/g, '');
    
    // 检查开标签（非自闭合）
    if (processLine.includes('<view') && !processLine.includes('/>')) {
        // 提取 class 或其他属性
        const match = processLine.match(/<view[^>]*>/);
        if (match) {
            const classMatch = match[0].match(/class="([^"]*)"/);
            const vIfMatch = match[0].match(/v-(if|else-if|else)/);
            const label = classMatch ? classMatch[1] : (vIfMatch ? vIfMatch[0] : 'unnamed');
            stack.push({ line: lineNum, label });
            console.log(`${lineNum.toString().padStart(4)}: ${'  '.repeat(stack.length-1)}▶ OPEN: ${label}`);
        }
    }
    
    // 检查闭标签
    if (processLine.includes('</view>')) {
        const count = (processLine.match(/<\/view>/g) || []).length;
        for (let j = 0; j < count; j++) {
            if (stack.length > 0) {
                const popped = stack.pop();
                console.log(`${lineNum.toString().padStart(4)}: ${'  '.repeat(stack.length)}◀ CLOSE: ${popped.label} (opened at line ${popped.line})`);
            } else {
                console.log(`${lineNum.toString().padStart(4)}: ❌ EXTRA CLOSING TAG!`);
            }
        }
    }
}

if (stack.length > 0) {
    console.log('\n\n❌ 未闭合的标签：\n');
    stack.forEach((item, index) => {
        console.log(`${index + 1}. 第 ${item.line} 行: ${item.label}`);
    });
} else {
    console.log('\n\n✅ 所有标签已正确匹配');
}

