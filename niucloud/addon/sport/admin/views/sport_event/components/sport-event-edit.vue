<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateSportEvent') : t('addSportEvent')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('seriesId')" >
                    <el-input v-model="formData.series_id" clearable :placeholder="t('seriesIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('name')" prop="name">
                    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('eventType')" prop="event_type">
                    <el-input v-model="formData.event_type" clearable :placeholder="t('eventTypePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('year')" prop="year">
                    <el-input v-model="formData.year" clearable :placeholder="t('yearPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('season')" >
                    <el-input v-model="formData.season" clearable :placeholder="t('seasonPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('startTime')" prop="start_time">
                    <el-input v-model="formData.start_time" clearable :placeholder="t('startTimePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('endTime')" prop="end_time">
                    <el-input v-model="formData.end_time" clearable :placeholder="t('endTimePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('location')" prop="location">
                    <el-input v-model="formData.location" clearable :placeholder="t('locationPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('organizerId')" prop="organizer_id">
                    <el-input v-model="formData.organizer_id" clearable :placeholder="t('organizerIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('organizerType')" prop="organizer_type">
                    <el-input v-model="formData.organizer_type" clearable :placeholder="t('organizerTypePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('sort')" prop="sort">
                    <el-input v-model="formData.sort" clearable :placeholder="t('sortPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('status')" prop="status">
                    <el-radio-group  v-model="formData.status" :placeholder="t('statusPlaceholder')">
                        <el-radio
                            v-for="(item, index) in statusList"
                            :key="index" :label="item.value">
                              {{ item.name }}
                        </el-radio>
                    </el-radio-group>
                </el-form-item>
                
                <el-form-item :label="t('remark')" >
                    <el-input v-model="formData.remark" clearable :placeholder="t('remarkPlaceholder')" class="input-width" />
                </el-form-item>
                
        </el-form>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{
                    t('confirm')
                }}</el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { addSportEvent, editSportEvent, getSportEventInfo } from '@/addon/sport/api/sport_event'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    series_id: '',
    name: '',
    event_type: '',
    year: '',
    season: '',
    start_time: '',
    end_time: '',
    location: '',
    organizer_id: '',
    organizer_type: '',
    sort: '',
    status: '',
    remark: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    series_id: [
        { required: true, message: t('seriesIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    name: [
        { required: true, message: t('namePlaceholder'), trigger: 'blur' },
        
    ]
,
    event_type: [
        { required: true, message: t('eventTypePlaceholder'), trigger: 'blur' },
        
    ]
,
    year: [
        { required: true, message: t('yearPlaceholder'), trigger: 'blur' },
        
    ]
,
    season: [
        { required: true, message: t('seasonPlaceholder'), trigger: 'blur' },
        
    ]
,
    start_time: [
        { required: true, message: t('startTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    end_time: [
        { required: true, message: t('endTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    location: [
        { required: true, message: t('locationPlaceholder'), trigger: 'blur' },
        
    ]
,
    organizer_id: [
        { required: true, message: t('organizerIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    organizer_type: [
        { required: true, message: t('organizerTypePlaceholder'), trigger: 'blur' },
        
    ]
,
    sort: [
        { required: true, message: t('sortPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    remark: [
        { required: true, message: t('remarkPlaceholder'), trigger: 'blur' },
        
    ]

    }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    let save = formData.id ? editSportEvent : addSportEvent

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true

            let data = formData

            save(data).then(res => {
                loading.value = false
                showDialog.value = false
                emit('complete')
            }).catch(err => {
                loading.value = false
            })
        }
    })
}

// 获取字典数据
    let statusList = ref([])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();
    watch(() => statusList.value, () => { formData.status = statusList.value[0].value })

    
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if(row){
        const data = await (await getSportEventInfo(row.id)).data
        if (data) Object.keys(formData).forEach((key: string) => {
            if (data[key] != undefined) formData[key] = data[key]
        })
    }
    loading.value = false
}

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error(t('generateMobile')))
    } else {
        callback()
    }
}

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
        callback(new Error(t('generateIdCard')))
    } else {
        callback()
    }
}

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
    if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
        callback(new Error(t('generateEmail')))
    } else {
        callback()
    }
}

// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
    if (!Number.isInteger(value)) {
        callback(new Error(t('generateNumber')))
    } else {
        callback()
    }
}

defineExpose({
    showDialog,
    setFormData
})
</script>

<style lang="scss" scoped></style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label{
    height: auto  !important;
}
</style>
