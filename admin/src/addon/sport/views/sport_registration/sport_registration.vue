<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportRegistration') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportRegistrationTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('eventId')" prop="event_id">
                        <el-input v-model="sportRegistrationTable.searchParam.event_id" :placeholder="t('eventIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('itemId')" prop="item_id">
                        <el-input v-model="sportRegistrationTable.searchParam.item_id" :placeholder="t('itemIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('athleteId')" prop="athlete_id">
                        <el-input v-model="sportRegistrationTable.searchParam.athlete_id" :placeholder="t('athleteIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('teamId')" prop="team_id">
                        <el-input v-model="sportRegistrationTable.searchParam.team_id" :placeholder="t('teamIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('registrationType')" prop="registration_type">
                        <el-input v-model="sportRegistrationTable.searchParam.registration_type" :placeholder="t('registrationTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('registrationTime')" prop="registration_time">
                        <el-input v-model="sportRegistrationTable.searchParam.registration_time" :placeholder="t('registrationTimePlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportRegistrationTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('paymentStatus')" prop="payment_status">
                        <el-input v-model="sportRegistrationTable.searchParam.payment_status" :placeholder="t('paymentStatusPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('paymentTime')" prop="payment_time">
                        <el-input v-model="sportRegistrationTable.searchParam.payment_time" :placeholder="t('paymentTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportRegistrationTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="sportRegistrationTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportRegistrationTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportRegistrationTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportRegistrationList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportRegistrationTable.data" size="large" v-loading="sportRegistrationTable.loading">
                    <template #empty>
                        <span>{{ !sportRegistrationTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="event_id" :label="t('eventId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="item_id" :label="t('itemId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="athlete_id" :label="t('athleteId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="team_id" :label="t('teamId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="registration_type" :label="t('registrationType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="registration_time" :label="t('registrationTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="payment_status" :label="t('paymentStatus')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="payment_time" :label="t('paymentTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sportRegistrationTable.page" v-model:page-size="sportRegistrationTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportRegistrationTable.total"
                        @size-change="loadSportRegistrationList()" @current-change="loadSportRegistrationList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportRegistrationList, deleteSportRegistration } from '@/addon/sport/api/sport_registration'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportRegistrationTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "event_id":"",
      "item_id":"",
      "athlete_id":"",
      "team_id":"",
      "registration_type":"",
      "registration_time":"",
      "status":"",
      "payment_status":"",
      "payment_time":"",
      "sort":"",
      "remark":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取报名记录列表
 */
const loadSportRegistrationList = (page: number = 1) => {
    sportRegistrationTable.loading = true
    sportRegistrationTable.page = page

    getSportRegistrationList({
        page: sportRegistrationTable.page,
        limit: sportRegistrationTable.limit,
         ...sportRegistrationTable.searchParam
    }).then(res => {
        sportRegistrationTable.loading = false
        sportRegistrationTable.data = res.data.data
        sportRegistrationTable.total = res.data.total
    }).catch(() => {
        sportRegistrationTable.loading = false
    })
}
loadSportRegistrationList()

const router = useRouter()

/**
 * 添加报名记录
 */
const addEvent = () => {
    router.push('/sport_registration/sport_registration_edit')
}

/**
 * 编辑报名记录
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_registration/sport_registration_edit?id='+data.id)
}

/**
 * 删除报名记录
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportRegistrationDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportRegistration(id).then(() => {
            loadSportRegistrationList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportRegistrationList()
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
		word-break: break-all;
		text-overflow: ellipsis;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
