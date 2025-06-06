<template>
    <div class="main-container">
        <div class="detail-head">
            <div class="left" @click="back()">
                <span class="iconfont iconxiangzuojiantou !text-xs"></span>
                <span class="ml-[1px]">{{t('returnToPreviousPage')}}</span>
            </div>
            <span class="adorn">|</span>
            <span class="right">{{ pageName }}</span>
        </div>
        <el-card class="box-card !border-none" shadow="never">
            <el-form :model="formData" label-width="90px" ref="formRef" :rules="formRules" class="page-form">
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
        </el-card>
         <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" @click="onSave(formRef)">{{ t('save') }}</el-button>
                <el-button @click="back()">{{ t('cancel') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import type { FormInstance } from 'element-plus'
import { getSportEventInfo,addSportEvent,editSportEvent } from '@/addon/sport/api/sport_event';
import { useRoute } from 'vue-router'

const route = useRoute()
const id:number = parseInt(route.query.id);
const loading = ref(false)
const pageName = route.meta.title



/**
 * 表单数据
 */
const initialFormData = {
    id: 0,
    series_id: 0,
    name: '',
    event_type: 0,
    year: 0,
    season: '',
    start_time: 0,
    end_time: 0,
    location: '',
    organizer_id: 0,
    organizer_type: 0,
    sort: 0,
    status: 0,
    remark: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id:number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getSportEventInfo(id)).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
}
if(id) setFormData(id);

const formRef = ref<FormInstance>()
// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    let statusList = ref([])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();
    watch(() => statusList.value, () => { formData.status = statusList.value[0].value })

    
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

const onSave = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    await formEl.validate(async (valid) => {
       if (valid) {
           loading.value = true
           let data = formData

           const save = id ? editSportEvent : addSportEvent
           save(data).then(res => {
               loading.value = false
               history.back()
           }).catch(err => {
               loading.value = false
           })

       }
    })
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
const back = () => {
    history.back()
}
</script>

<style lang="scss" scoped></style>
